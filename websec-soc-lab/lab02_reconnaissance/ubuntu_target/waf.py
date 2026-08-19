import http.server
import socketserver
import urllib.request
import urllib.parse
import os
import sys
import json
import sqlite3
from datetime import datetime

WAF_PORT = 6002
TARGET_PORT = 5002
TARGET_URL = f"http://127.0.0.1:{TARGET_PORT}"
DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "security.db")
LOG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "waf.log")

SIGNATURES = {
    "SQL_INJECTION": ["UNION", "SELECT", "DROP", "OR 1=1", "' OR '", "--"],
    "XSS": ["<SCRIPT", "JAVASCRIPT:", "ONERROR=", "ALERT("],
    "PATH_TRAVERSAL": ["../", "..\\", "%2E%2E"],
    "COMMAND_INJECTION": [";", "&&", "||", "`"],
    "RECONNAISSANCE": ["NMAP", "SQLMAP", "NIKTO", "GOBUSTER", "DIRBUST"],
    "UNAUTHORIZED_ACCESS": ["/ADMIN"]
}

def log_to_db(ip, method, url, attack_type, severity, waf_action, rule_id, payload):
    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO security_events (source_ip, method, url, attack_type, severity, waf_action, rule_id, payload)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (ip, method, url, attack_type, severity, waf_action, rule_id, payload))
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Error logging to DB: {e}")

    log_entry = f"[{datetime.now().isoformat()}] IP={ip} METHOD={method} URL={url} TYPE={attack_type} ACTION={waf_action}\n"
    with open(LOG_PATH, "a") as f:
        f.write(log_entry)

class WAFProxyHandler(http.server.BaseHTTPRequestHandler):
    def inspect_request(self, body=""):
        full_url = self.path.upper()
        user_agent = self.headers.get("User-Agent", "").upper()
        content = (full_url + " " + user_agent + " " + body.upper())
        
        detected_type = None
        rule_id = None
        severity = "LOW"

        for pattern in SIGNATURES["RECONNAISSANCE"]:
            if pattern in user_agent:
                detected_type = "RECONNAISSANCE"
                rule_id = "RULE-RECON-01"
                severity = "MEDIUM"
                break
        
        if not detected_type:
            for attack, patterns in SIGNATURES.items():
                for pat in patterns:
                    if pat in content:
                        detected_type = attack
                        rule_id = f"RULE-{attack[:5]}-01"
                        severity = "HIGH" if attack in ["SQL_INJECTION", "COMMAND_INJECTION", "UNAUTHORIZED_ACCESS"] else "MEDIUM"
                        break
                if detected_type:
                    break

        return detected_type, severity, rule_id

    def do_GET(self):
        self.handle_proxy("GET")

    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length).decode('utf-8', errors='ignore') if content_length > 0 else ""
        self.handle_proxy("POST", body)

    def handle_proxy(self, method, body=""):
        client_ip = self.client_address[0]
        detected_type, severity, rule_id = self.inspect_request(body)

        action = "ALLOWED"
        if detected_type and "lab02" != "lab01":
            action = "BLOCKED"

        if detected_type:
            log_to_db(client_ip, method, self.path, detected_type, severity, action, rule_id or "RULE-GENERIC", body[:100])
        else:
            log_to_db(client_ip, method, self.path, "BASELINE_TRAFFIC", "LOW", "ALLOWED", "RULE-INFO-00", body[:100])

        if action == "BLOCKED":
            self.send_response(403)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            resp = {
                "error": "WAF Blocked Request",
                "reason": f"Security violation detected: {detected_type}",
                "rule_id": rule_id,
                "lab": "Lab 02 — Reconnaissance"
            }
            self.wfile.write(json.dumps(resp).encode('utf-8'))
            return

        backend_url = f"http://127.0.0.1:5002{self.path}"
        headers = {k: v for k, v in self.headers.items() if k.lower() != 'host'}
        
        req = urllib.request.Request(backend_url, data=body.encode('utf-8') if body else None, headers=headers, method=method)
        try:
            with urllib.request.urlopen(req) as response:
                self.send_response(response.status)
                for k, v in response.headers.items():
                    self.send_header(k, v)
                self.end_headers()
                self.wfile.write(response.read())
        except urllib.error.HTTPError as e:
            self.send_response(e.code)
            self.end_headers()
            self.wfile.write(e.read())
        except Exception as e:
            self.send_response(502)
            self.end_headers()
            self.wfile.write(json.dumps({"error": "Backend unreachable", "details": str(e)}).encode('utf-8'))

if __name__ == '__main__':
    conn = sqlite3.connect(DB_PATH)
    conn.close()
    print(f"Starting Python WAF on port {WAF_PORT} -> Forwarding to {TARGET_PORT}...")
    with socketserver.TCPServer(("0.0.0.0", WAF_PORT), WAFProxyHandler) as httpd:
        httpd.serve_forever()

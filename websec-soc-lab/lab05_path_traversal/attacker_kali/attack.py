import requests
import sys

TARGET_HOST = "127.0.0.1"
WAF_PORT = 6005
BASE_URL = f"http://{TARGET_HOST}:{WAF_PORT}"

def check_target():
    print("[1/5] Checking target connectivity...")
    try:
        r = requests.get(f"{BASE_URL}/health", timeout=3)
        if r.status_code == 200:
            print("  [OK] Target reached successfully.")
            return True
    except Exception as e:
        print(f"  [FAIL] Target unreachable: {e}")
        return False
    return False

def send_baseline():
    print("[2/5] Sending baseline normal request...")
    r = requests.get(f"{BASE_URL}/")
    print(f"  Response Status: {r.status_code}")

def send_attack():
    print("[3/5] Sending automated training payload...")
    attack_type = "PATH_TRAVERSAL"
    
    if attack_type == "SQL_INJECTION":
        url = f"{BASE_URL}/search?q=' OR '1'='1"
        r = requests.get(url)
        print(f"  SQLi Payload sent. WAF Status Code: {r.status_code}")
    elif attack_type == "XSS":
        url = f"{BASE_URL}/search?q=<script>alert('XSS')</script>"
        r = requests.get(url)
        print(f"  XSS Payload sent. WAF Status Code: {r.status_code}")
    elif attack_type == "PATH_TRAVERSAL":
        url = f"{BASE_URL}/view_file?file=../../etc/passwd"
        r = requests.get(url)
        print(f"  Path Traversal Payload sent. WAF Status Code: {r.status_code}")
    elif attack_type == "COMMAND_INJECTION":
        url = f"{BASE_URL}/tools/ping"
        r = requests.post(url, json={"target": "127.0.0.1; whoami"})
        print(f"  Command Injection Payload sent. WAF Status Code: {r.status_code}")
    elif attack_type == "RECONNAISSANCE":
        headers = {"User-Agent": "Nmap Scripting Engine / Nikto"}
        r = requests.get(f"{BASE_URL}/admin", headers=headers)
        print(f"  Recon payload sent. WAF Status Code: {r.status_code}")
    elif attack_type == "BRUTE_FORCE":
        for i in range(4):
            requests.post(f"{BASE_URL}/login", json={"username": "admin", "password": f"wrong_{i} text"})
        print("  Brute force sequence executed.")
    elif attack_type == "PARAMETER_TAMPERING":
        r = requests.get(f"{BASE_URL}/profile?id=1")
        r2 = requests.get(f"{BASE_URL}/profile?id=2")
        print(f"  Parameter tampering sent. Status: {r2.status_code}")
    elif attack_type == "UNAUTHORIZED_ACCESS":
        r = requests.get(f"{BASE_URL}/admin")
        print(f"  Unauthorized access request sent. WAF Status Code: {r.status_code}")
    else:
        r = requests.get(f"{BASE_URL}/search?q=normal_query")
        print(f"  Normal baseline request sent. Status: {r.status_code}")

def main():
    print("========================================")
    print(" AUTOMATED ATTACK DEMONSTRATION")
    print(" Lab 05 — Path Traversal")
    print("========================================")
    
    if not check_target():
        sys.exit(1)
        
    send_baseline()
    send_attack()
    
    print("[4/5] Attack simulation sequence complete.")
    print("[5/5] Check SOC Viewer to observe generated security logs.")
    print("========================================")

if __name__ == "__main__":
    main()

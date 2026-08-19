from flask import Flask, jsonify, render_template_string
import sqlite3
import os

app = Flask(__name__)
DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "ubuntu_target", "security.db")

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>SOC Log Viewer — {{ lab_title }}</title>
    <style>
        body { font-family: monospace; background: #0f172a; color: #f8fafc; padding: 20px; }
        h1 { color: #38bdf8; }
        .card-container { display: flex; gap: 15px; margin-bottom: 20px; }
        .card { background: #1e293b; padding: 15px; border-radius: 8px; flex: 1; border: 1px solid #334155; }
        .card h3 { margin: 0 0 10px 0; color: #94a3b8; font-size: 14px; }
        .card p { margin: 0; font-size: 24px; font-weight: bold; color: #38bdf8; }
        table { width: 100%; border-collapse: collapse; background: #1e293b; border-radius: 8px; overflow: hidden; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #334155; }
        th { background: #0f172a; color: #94a3b8; }
        .badge-HIGH { background: #ef4444; color: white; padding: 3px 8px; border-radius: 4px; }
        .badge-MEDIUM { background: #f59e0b; color: white; padding: 3px 8px; border-radius: 4px; }
        .badge-LOW { background: #10b981; color: white; padding: 3px 8px; border-radius: 4px; }
    </style>
</head>
<body>
    <h1>🛡️ SOC Security Dashboard — {{ lab_title }}</h1>
    <div class="card-container">
        <div class="card"><h3>TOTAL REQUESTS</h3><p>{{ total_reqs }}</p></div>
        <div class="card"><h3>SECURITY ALERTS</h3><p>{{ total_alerts }}</p></div>
        <div class="card"><h3>BLOCKED REQUESTS</h3><p>{{ total_blocked }}</p></div>
    </div>
    
    <h2>Recent Security Events</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th><th>Timestamp</th><th>IP</th><th>Method</th><th>URL</th><th>Attack Type</th><th>Severity</th><th>WAF Action</th>
            </tr>
        </thead>
        <tbody>
            {% for event in events %}
            <tr>
                <td>{{ event[0] }}</td>
                <td>{{ event[1] }}</td>
                <td>{{ event[2] }}</td>
                <td>{{ event[3] }}</td>
                <td>{{ event[4] }}</td>
                <td><strong>{{ event[5] }}</strong></td>
                <td><span class="badge-{{ event[6] }}">{{ event[6] }}</span></td>
                <td>{{ event[7] }}</td>
            </tr>
            {% else %}
            <tr><td colspan="8">No events logged yet. Execute attack simulation to generate traffic.</td></tr>
            {% endfor %}
        </tbody>
    </table>
</body>
</html>
"""

@app.route('/')
def dashboard():
    total_reqs, total_alerts, total_blocked = 0, 0, 0
    events = []
    if os.path.exists(DB_PATH):
        try:
            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()
            cursor.execute("SELECT count(*) FROM security_events")
            total_reqs = cursor.fetchone()[0]
            
            cursor.execute("SELECT count(*) FROM security_events WHERE attack_type != 'BASELINE_TRAFFIC'")
            total_alerts = cursor.fetchone()[0]
            
            cursor.execute("SELECT count(*) FROM security_events WHERE waf_action = 'BLOCKED'")
            total_blocked = cursor.fetchone()[0]
            
            cursor.execute("SELECT * FROM security_events ORDER BY id DESC LIMIT 20")
            events = cursor.fetchall()
            conn.close()
        except Exception:
            pass
            
    return render_template_string(HTML_TEMPLATE, lab_title="Lab 05 — Path Traversal", total_reqs=total_reqs, total_alerts=total_alerts, total_blocked=total_blocked, events=events)

@app.route('/api/events')
def api_events():
    events = []
    if os.path.exists(DB_PATH):
        try:
            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM security_events ORDER BY id DESC")
            events = cursor.fetchall()
            conn.close()
        except Exception:
            pass
    return jsonify({"events": events})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8005, debug=False)

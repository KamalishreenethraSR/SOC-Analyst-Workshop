from flask import Flask, request, jsonify, render_template_string
import sqlite3
import os
import json

app = Flask(__name__)
TRAINING_MODE = True
DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "security.db")
LAB_FILES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "lab_files")

os.makedirs(LAB_FILES_DIR, exist_ok=True)
sample_file = os.path.join(LAB_FILES_DIR, "welcome.txt")
if not os.path.exists(sample_file):
    with open(sample_file, "w") as f:
        f.write("Welcome to Lab 01 — HTTP Baseline lab environment!")

@app.route('/')
def index():
    return jsonify({
        "status": "online",
        "lab": "Lab 01 — HTTP Baseline",
        "training_mode": TRAINING_MODE,
        "message": "Target web application running."
    })

@app.route('/health')
def health():
    return jsonify({"status": "OK", "lab_id": "lab01"})

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        data = request.get_json(silent=True) or request.form
        username = data.get('username', '')
        password = data.get('password', '')
        
        if "lab01" == "lab03" and ("'" in username or "OR" in username.upper()):
            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()
            try:
                query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
                cursor.execute(query)
                user = cursor.fetchone()
                if user:
                    return jsonify({"status": "success", "user": user[1], "role": user[3]})
            except Exception as e:
                return jsonify({"status": "error", "message": str(e)}), 500
        
        if username == 'admin' and password == 'admin123':
            return jsonify({"status": "success", "message": "Login successful"})
        return jsonify({"status": "failed", "message": "Invalid credentials"}), 401
    return jsonify({"endpoint": "/login", "method": "POST", "fields": ["username", "password"]})

@app.route('/search')
def search():
    q = request.args.get('q', '')
    if "lab01" == "lab04":
        return render_template_string(f"<h1>Search Results for: {q}</h1>")
    if "lab01" == "lab03" and ("'" in q or "SELECT" in q.upper()):
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        try:
            cursor.execute(f"SELECT * FROM users WHERE username LIKE '%{q}%'")
            results = cursor.fetchall()
            return jsonify({"query": q, "results": results})
        except Exception as e:
            return jsonify({"error": str(e)}), 500
    return jsonify({"query": q, "results": ["sample_result_1", "sample_result_2"]})

@app.route('/view_file')
def view_file():
    filename = request.args.get('file', 'welcome.txt')
    file_path = os.path.join(LAB_FILES_DIR, filename)
    if os.path.exists(file_path) and os.path.isfile(file_path):
        with open(file_path, 'r') as f:
            content = f.read()
        return jsonify({"file": filename, "content": content})
    return jsonify({"error": "File not found"}), 404

@app.route('/tools/ping', methods=['POST'])
def ping_tool():
    data = request.get_json(silent=True) or request.form
    target = data.get('target', '127.0.0.1')
    return jsonify({
        "status": "executed",
        "command": f"ping -c 1 {target}",
        "output": f"PING {target} (127.0.0.1) 56(84) bytes of data.\n64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.045 ms",
        "note": "Sandboxed output for lab demonstration."
    })

@app.route('/profile')
def profile():
    user_id = request.args.get('id', '1')
    return jsonify({
        "user_id": user_id,
        "username": f"user_{user_id}",
        "email": f"user_{user_id}@example.lab",
        "role": "administrator" if user_id == "1" else "student"
    })

@app.route('/admin')
def admin():
    auth_header = request.headers.get('Authorization', '')
    if auth_header != 'Bearer admin-secret-token':
        return jsonify({"error": "Unauthorized access to /admin"}), 403
    return jsonify({"status": "welcome_admin", "secret": "LAB_FLAG_ACCESS_GRANTED"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=False)

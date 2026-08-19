import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "security.db")

def init_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS security_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            source_ip TEXT,
            method TEXT,
            url TEXT,
            attack_type TEXT,
            severity TEXT,
            waf_action TEXT,
            rule_id TEXT,
            payload TEXT
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            role TEXT
        )
    """)
    cursor.execute("SELECT count(*) FROM users")
    if cursor.fetchone()[0] == 0:
        cursor.execute("INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'administrator')")
        cursor.execute("INSERT INTO users (username, password, role) VALUES ('student', 'student123', 'user')")
    conn.commit()
    conn.close()

def log_event(source_ip, method, url, attack_type, severity, waf_action, rule_id, payload=""):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO security_events (source_ip, method, url, attack_type, severity, waf_action, rule_id, payload)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (source_ip, method, url, attack_type, severity, waf_action, rule_id, payload))
    conn.commit()
    conn.close()

if __name__ == "__main__":
    init_db()
    print("Database initialized at:", DB_PATH)

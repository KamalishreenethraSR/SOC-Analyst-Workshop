#!/usr/bin/env bash
# lib-state.sh — Manages course and lab execution state in state/*.json

STATE_DIR="${SCRIPT_DIR:-.}/state"

init_state() {
    mkdir -p "$STATE_DIR"
    if [ ! -f "$STATE_DIR/course-state.json" ]; then
        cat << 'EOF' > "$STATE_DIR/course-state.json"
{
  "installed": false,
  "profile": "unknown",
  "last_updated": "",
  "labs": {
    "1.1": {"status": "not_started", "verified": false},
    "2.1": {"status": "not_started", "verified": false},
    "3.1": {"status": "not_started", "verified": false},
    "4.1": {"status": "not_started", "verified": false},
    "5.1": {"status": "not_started", "verified": false},
    "6.1": {"status": "not_started", "verified": false}
  }
}
EOF
    fi
}

get_lab_status() {
    local lab_id="$1"
    python3 -c "import json; data=json.load(open('$STATE_DIR/course-state.json')); print(data.get('labs',{}).get('$lab_id',{}).get('status','not_started'))" 2>/dev/null || echo "unknown"
}

set_lab_state() {
    local lab_id="$1"
    local status="$2"
    local verified="${3:-False}"
    python3 -c "import json, time; data=json.load(open('$STATE_DIR/course-state.json')); data['labs']['$lab_id']={'status':'$status','verified':$verified,'updated':time.strftime('%Y-%m-%d %H:%M:%S')}; json.dump(data,open('$STATE_DIR/course-state.json','w'),indent=2)"
}

set_course_state() {
    local installed="$1"
    local profile="$2"
    python3 -c "import json, time; data=json.load(open('$STATE_DIR/course-state.json')); data['installed']=$installed; data['profile']='$profile'; data['last_updated']=time.strftime('%Y-%m-%d %H:%M:%S'); json.dump(data,open('$STATE_DIR/course-state.json','w'),indent=2)"
}

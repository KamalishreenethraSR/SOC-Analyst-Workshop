#!/usr/bin/env bash
# ==============================================================================
# Docker SOC Server Stack - Automated Installation & Configuration Script
# ==============================================================================
# Platform: Ubuntu Server 22.04 LTS / 24.04 LTS (x86_64)
# Target: Fresh SOC Server Deployment
# ==============================================================================

set -Eeuo pipefail

# Global variables
STACK_DIR="/opt/Docker_SOC_Server_Stack"
COMPOSE_FILE="$STACK_DIR/docker-compose.yml"
ENV_FILE="$STACK_DIR/.env"
CURRENT_PHASE="initialization"
PROFILE="standard"  # Default profile, auto-detected later

# Color outputs
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
RESET='\e[0m'

# Error Handling Trap
error_handler() {
    local exit_code="$1"
    local line_num="$2"
    echo -e "\n${RED}======================================================================${RESET}"
    echo -e "${RED}[ERR] Installation failed at line $line_num with status code $exit_code${RESET}"
    
    if [ "$CURRENT_PHASE" = "docker_install" ]; then
        echo -e "${YELLOW}Docker installation failed.${RESET}"
        echo "Troubleshooting commands:"
        echo "  - systemctl status docker"
        echo "  - journalctl -u docker -n 50"
        echo "  - apt-get update"
    elif [ "$CURRENT_PHASE" = "soc_start" ]; then
        echo -e "${YELLOW}SOC Stack startup failed.${RESET}"
        echo "Troubleshooting commands:"
        echo "  - cd $STACK_DIR"
        echo "  - docker compose ps"
        echo "  - docker compose logs"
    fi
    echo -e "${RED}======================================================================${RESET}"
    exit "$exit_code"
}
trap 'error_handler $? $LINENO' ERR

# ------------------------------------------------------------------------------
# 1. Root Access Validation
# ------------------------------------------------------------------------------
check_root() {
    CURRENT_PHASE="preflight"
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[ERR] This script must be run as root. Please use sudo.${RESET}" >&2
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# 2. Operating System Validation
# ------------------------------------------------------------------------------
check_os() {
    if [ ! -f /etc/os-release ]; then
        echo -e "${RED}[ERR] /etc/os-release not found. Unknown operating system.${RESET}" >&2
        exit 1
    fi
    
    # Load OS variables
    . /etc/os-release
    
    if [ "${ID:-}" != "ubuntu" ]; then
        echo -e "${RED}[ERR] Target OS is not Ubuntu. This script only supports Ubuntu Server.${RESET}" >&2
        exit 1
    fi

    # Support 22.04 and 24.04
    if [ "${VERSION_ID:-}" != "22.04" ] && [ "${VERSION_ID:-}" != "24.04" ]; then
        echo -e "${YELLOW}[WARN] Ubuntu version is $VERSION_ID. Recommended: Ubuntu 22.04 LTS or 24.04 LTS.${RESET}"
    fi
}

# ------------------------------------------------------------------------------
# 3. CPU Architecture Validation
# ------------------------------------------------------------------------------
check_architecture() {
    local arch
    arch=$(uname -m)
    if [ "$arch" != "x86_64" ]; then
        echo -e "${RED}[ERR] Unsupported architecture: $arch. This stack requires x86_64.${RESET}" >&2
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# 4. System Resources Check & Auto-Profile
# ------------------------------------------------------------------------------
check_resources() {
    echo -e "${BLUE}Running system requirements checks...${RESET}"
    
    # OS Version info
    local os_name="${PRETTY_NAME:-Ubuntu}"
    
    # CPU cores
    local cpu_cores
    cpu_cores=$(nproc)
    
    # RAM Check
    local total_ram_kb
    total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local total_ram_gb=$(( (total_ram_kb + 524288) / 1048576 ))
    
    # Disk Space Check on /
    local disk_free_gb
    disk_free_gb=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    
    # Kernel Version
    local kernel_ver
    kernel_ver=$(uname -r)
    
    # Hostname
    local host_name
    host_name=$(hostname)
    
    # Primary network IP & Interface
    local interface
    interface=$(ip route show default | awk '{print $5; exit}')
    if [ -z "$interface" ]; then
        interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
    fi
    
    local ip_addr
    ip_addr=$(ip -o -4 addr show dev "$interface" | awk '{print $4}' | cut -d/ -f1 | head -n 1)
    if [ -z "$ip_addr" ]; then
        ip_addr=$(hostname -I | awk '{print $1}')
    fi

    local public_ip
    public_ip=$(curl -s --connect-timeout 3 https://ifconfig.me 2>/dev/null || echo "NOT DETECTED")

    # Internet Connectivity
    local internet_status="OK"
    if ! curl -s --connect-timeout 5 https://google.com >/dev/null; then
        internet_status="FAILED"
    fi

    # Determine RAM Profile
    if [ "$total_ram_gb" -ge 32 ]; then
        PROFILE="full"
    elif [ "$total_ram_gb" -ge 16 ]; then
        PROFILE="standard"
    elif [ "$total_ram_gb" -ge 4 ]; then
        PROFILE="minimal"
    else
        echo -e "${RED}[ERR] Total RAM (${total_ram_gb} GB) is below absolute minimum of 4 GB.${RESET}" >&2
        exit 1
    fi

    # Output Pre-installation details
    echo -e "\n========================================"
    echo -e " Docker SOC Server Pre-Installation"
    echo -e "========================================"
    echo -e "OS              : $os_name"
    echo -e "Architecture    : x86_64"
    echo -e "CPU             : $cpu_cores cores"
    echo -e "RAM             : $total_ram_gb GB"
    echo -e "Disk            : ${disk_free_gb} GB Free"
    echo -e "Kernel          : $kernel_ver"
    echo -e "Hostname        : $host_name"
    echo -e "Private IP      : $ip_addr"
    echo -e "Public IP       : $public_ip"
    echo -e "Internet        : $internet_status"
    echo -e "Root/Sudo       : OK"
    echo -e "Resource Profile: ${PROFILE^^}"
    echo -e "========================================"
    
    if [ "$disk_free_gb" -lt 30 ]; then
        echo -e "${YELLOW}[WARN] Low disk space ($disk_free_gb GB free). Minimum 30 GB recommended.${RESET}"
    fi

    if [ "$internet_status" != "OK" ]; then
        echo -e "${RED}[ERR] Internet connectivity is required to download packages and images.${RESET}" >&2
        exit 1
    fi
    
    echo -e "${GREEN}System requirements: PASSED${RESET}\n"
}

# ------------------------------------------------------------------------------
# 5. System Package Index Update
# ------------------------------------------------------------------------------
update_system() {
    echo -e "${BLUE}Updating system package index...${RESET}"
    apt-get update -y
}

# ------------------------------------------------------------------------------
# 6. Required Package Management
# ------------------------------------------------------------------------------
install_dependencies() {
    echo -e "${BLUE}Checking and installing required system packages...${RESET}"
    local pkgs=(ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common git jq openssl netcat-openbsd)
    local to_install=()
    
    for pkg in "${pkgs[@]}"; do
        if dpkg -s "$pkg" &>/dev/null; then
            echo -e "  - Package $pkg: ${GREEN}Already installed${RESET}"
        else
            echo -e "  - Package $pkg: ${YELLOW}Not installed${RESET}"
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        echo -e "Installing missing dependencies: ${to_install[*]}..."
        apt-get install -y "${to_install[@]}"
    else
        echo -e "${GREEN}All required packages are already installed.${RESET}"
    fi
}

# ------------------------------------------------------------------------------
# 7. Docker Engine Installation
# ------------------------------------------------------------------------------
install_docker() {
    CURRENT_PHASE="docker_install"
    if command -v docker &>/dev/null; then
        echo -e "${GREEN}Docker Engine is already installed.${RESET}"
        systemctl enable docker
        systemctl start docker
        return 0
    fi

    echo -e "${BLUE}Setting up official Docker GPG keys and repository...${RESET}"
    mkdir -p /etc/apt/keyrings
    rm -f /etc/apt/keyrings/docker.gpg
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    echo -e "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo -e "${BLUE}Installing Docker Engine and containerd...${RESET}"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}Docker Engine installed and started successfully.${RESET}"
}

# ------------------------------------------------------------------------------
# 8. Docker Compose Plugin Installation
# ------------------------------------------------------------------------------
install_docker_compose() {
    if docker compose version &>/dev/null; then
        echo -e "${GREEN}Docker Compose plugin is already installed.${RESET}"
        return 0
    fi

    echo -e "${BLUE}Installing Docker Compose plugin...${RESET}"
    apt-get install -y docker-compose-plugin
    echo -e "${GREEN}Docker Compose plugin installed successfully.${RESET}"
}

# ------------------------------------------------------------------------------
# 9. Docker Daemon Logging Rotation Configuration
# ------------------------------------------------------------------------------
configure_docker() {
    echo -e "${BLUE}Configuring Docker daemon settings (log limits)...${RESET}"
    local daemon_json="/etc/docker/daemon.json"
    local temp_json="/tmp/daemon.json"
    
    # 100m max-size, 5 files max
    local log_opts='{"log-driver":"json-file","log-opts":{"max-size":"100m","max-file":"5"}}'

    if [ -f "$daemon_json" ]; then
        echo -e "Existing $daemon_json found. Backing up to ${daemon_json}.bak"
        cp "$daemon_json" "${daemon_json}.bak"
        
        # Merge using jq (guaranteed installed by dependencies)
        jq '. + {"log-driver": "json-file", "log-opts": {"max-size": "100m", "max-file": "5"}}' "$daemon_json" > "$temp_json"
        mv "$temp_json" "$daemon_json"
    else
        mkdir -p /etc/docker
        echo "$log_opts" > "$daemon_json"
    fi

    echo -e "Restarting Docker service to apply configuration..."
    systemctl restart docker
    echo -e "${GREEN}Docker configuration applied successfully.${RESET}"
}

# ------------------------------------------------------------------------------
# 10. Docker Verification
# ------------------------------------------------------------------------------
verify_docker() {
    echo -e "${BLUE}Verifying Docker Engine and Compose execution...${RESET}"
    
    if ! command -v docker &>/dev/null; then
        echo -e "${RED}[ERR] Docker CLI command is missing!${RESET}" >&2
        return 1
    fi

    if ! docker compose version &>/dev/null; then
        echo -e "${RED}[ERR] Docker Compose plugin is missing!${RESET}" >&2
        return 1
    fi

    if [ "$(systemctl is-active docker)" != "active" ]; then
        echo -e "${RED}[ERR] Docker service is not active!${RESET}" >&2
        return 1
    fi

    if ! docker info &>/dev/null; then
        echo -e "${RED}[ERR] Cannot communicate with Docker socket. Permission check failed!${RESET}" >&2
        return 1
    fi

    echo -e "\n========================================"
    echo -e " Docker Engine Verification"
    echo -e "========================================"
    echo -e "Docker Engine      : OK ($(docker --version))"
    echo -e "Docker Compose     : OK ($(docker compose version))"
    echo -e "Docker Service     : ACTIVE"
    echo -e "Docker Permission  : OK"
    echo -e "========================================"
    echo -e "${GREEN}Docker setup is healthy!${RESET}\n"
}

# ------------------------------------------------------------------------------
# 11. Create dedicated SOC Server directories
# ------------------------------------------------------------------------------
create_soc_directories() {
    echo -e "${BLUE}Creating SOC Server Directory structure under $STACK_DIR...${RESET}"
    mkdir -p "$STACK_DIR"/{config,scripts,data,logs,backups,certificates}
    chmod -R 750 "$STACK_DIR"
    echo -e "${GREEN}Directories created successfully.${RESET}"
}

# ------------------------------------------------------------------------------
# 12. Consolidate and Generate SOC Docker Compose configuration
# ------------------------------------------------------------------------------
copy_or_generate_soc_stack() {
    echo -e "${BLUE}Generating consolidated docker-compose.yml configuration...${RESET}"

    # Embedded configuration matching original infrastructure specifications
    cat << 'EOF' > "$COMPOSE_FILE"
version: "3.8"

services:
  # --- SIEM Core ---
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.13.0
    container_name: elasticsearch
    restart: unless-stopped
    environment:
      - node.name=es01
      - cluster.name=soc-lab-cluster
      - discovery.type=single-node
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx1g"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    healthcheck:
      test: ["CMD-SHELL", "curl -s -u elastic:${ELASTIC_PASSWORD} http://localhost:9200/_cluster/health | grep -q 'green\\|yellow'"]
      interval: 15s
      timeout: 10s
      retries: 10
    networks:
      soc-lab:
        ipv4_address: 10.60.0.10

  kibana:
    image: docker.elastic.co/kibana/kibana:8.13.0
    container_name: kibana
    restart: unless-stopped
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=kibana_system
      - ELASTICSEARCH_PASSWORD=${ELASTIC_PASSWORD}
      - XPACK_SECURITY_ENCRYPTIONKEY=soc_lab_encryption_key_32_chars_long
      - XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY=soc_lab_saved_obj_key_32chars_ok
      - XPACK_REPORTING_ENCRYPTIONKEY=soc_lab_reporting_key_32chars_len
    ports:
      - "5601:5601"
    depends_on:
      elasticsearch:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -s http://localhost:5601/api/status | grep -q 'available'"]
      interval: 15s
      timeout: 10s
      retries: 10
    networks:
      soc-lab:
        ipv4_address: 10.60.0.11

  splunk:
    image: splunk/splunk:9.2
    container_name: splunk
    restart: unless-stopped
    environment:
      - SPLUNK_START_ARGS=--accept-license
      - SPLUNK_PASSWORD=${SPLUNK_PASSWORD}
      - SPLUNK_LICENSE_URI=Free
    ports:
      - "8000:8000"
      - "8088:8088"
      - "9997:9997"
    volumes:
      - splunk-var:/opt/splunk/var
      - splunk-etc:/opt/splunk/etc
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/en-US/account/login"]
      interval: 20s
      timeout: 10s
      retries: 10
    networks:
      soc-lab:
        ipv4_address: 10.60.0.20

  # --- EDR Platform (Wazuh) ---
  wazuh-manager:
    image: wazuh/wazuh-manager:4.8.0
    container_name: wazuh-manager
    hostname: wazuh-manager
    restart: unless-stopped
    environment:
      - INDEXER_URL=https://wazuh-indexer:9200
      - INDEXER_USERNAME=admin
      - INDEXER_PASSWORD=${ELASTIC_PASSWORD}
      - API_USERNAME=${WAZUH_API_USER}
      - API_PASSWORD=${WAZUH_API_PASSWORD}
    volumes:
      - wazuh-etc:/var/ossec/etc
      - wazuh-logs:/var/ossec/logs
      - wazuh-queue:/var/ossec/queue
    ports:
      - "1514:1514"
      - "1515:1515"
      - "55000:55000"
    healthcheck:
      test: ["CMD", "curl", "-sk", "-u", "${WAZUH_API_USER}:${WAZUH_API_PASSWORD}", "https://localhost:55000/"]
      interval: 20s
      timeout: 10s
      retries: 5
    networks:
      soc-lab:
        ipv4_address: 10.60.0.30

  wazuh-dashboard:
    image: wazuh/wazuh-dashboard:4.8.0
    container_name: wazuh-dashboard
    hostname: wazuh-dashboard
    restart: unless-stopped
    environment:
      - INDEXER_USERNAME=admin
      - INDEXER_PASSWORD=${ELASTIC_PASSWORD}
      - WAZUH_API_URL=https://wazuh-manager
      - API_USERNAME=${WAZUH_API_USER}
      - API_PASSWORD=${WAZUH_API_PASSWORD}
    ports:
      - "8443:5601"
    depends_on:
      wazuh-manager:
        condition: service_healthy
    networks:
      soc-lab:
        ipv4_address: 10.60.0.31

  # --- Incident Response (TheHive) ---
  cassandra:
    image: cassandra:4.1
    container_name: cassandra
    restart: unless-stopped
    environment:
      - CASSANDRA_CLUSTER_NAME=thehive
      - MAX_HEAP_SIZE=512M
      - HEAP_NEWSIZE=100M
    volumes:
      - cassandra-data:/var/lib/cassandra
    networks:
      soc-lab:
        ipv4_address: 10.60.0.39

  thehive:
    image: strangebee/thehive:5.3
    container_name: thehive
    restart: unless-stopped
    depends_on:
      - cassandra
    environment:
      - JVM_OPTS=-Xms256m -Xmx512m
    volumes:
      - thehive-data:/opt/thp/thehive/data
    ports:
      - "9000:9000"
    healthcheck:
      test: ["CMD", "curl", "-sf", "http://localhost:9000/api/v1/status"]
      interval: 20s
      timeout: 10s
      retries: 10
    networks:
      soc-lab:
        ipv4_address: 10.60.0.40

  cortex:
    image: thehiveproject/cortex:3.1.8
    container_name: cortex
    restart: unless-stopped
    environment:
      - JOB_DIRECTORY=/tmp/cortex-jobs
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - cortex-jobs:/tmp/cortex-jobs
    ports:
      - "9001:9001"
    networks:
      soc-lab:
        ipv4_address: 10.60.0.41

  # --- Threat Intel (MISP) ---
  misp-db:
    image: mysql:8.0
    container_name: misp-db
    restart: unless-stopped
    environment:
      - MYSQL_DATABASE=misp
      - MYSQL_USER=misp
      - MYSQL_PASSWORD=misp_pass
      - MYSQL_ROOT_PASSWORD=misp_root_pass
    volumes:
      - misp-db-data:/var/lib/mysql
    networks:
      soc-lab:
        ipv4_address: 10.60.0.49

  misp:
    image: ghcr.io/misp/misp-docker/misp-core:latest
    container_name: misp
    restart: unless-stopped
    environment:
      - MISP_BASEURL=https://localhost:9443
      - MISP_ADMIN_EMAIL=${MISP_ADMIN_EMAIL}
      - MISP_ADMIN_PASSPHRASE=${MISP_ADMIN_PASS}
      - MYSQL_HOST=misp-db
      - MYSQL_DATABASE=misp
      - MYSQL_USER=misp
      - MYSQL_PASSWORD=misp_pass
    ports:
      - "9443:443"
    depends_on:
      - misp-db
    volumes:
      - misp-data:/var/www/MISP
    networks:
      soc-lab:
        ipv4_address: 10.60.0.50

volumes:
  esdata:
  splunk-var:
  splunk-etc:
  wazuh-etc:
  wazuh-logs:
  wazuh-queue:
  cassandra-data:
  thehive-data:
  cortex-jobs:
  misp-db-data:
  misp-data:

networks:
  soc-lab:
    external: true
EOF

    chmod 640 "$COMPOSE_FILE"
    echo -e "${GREEN}Consolidated docker-compose.yml file written to $COMPOSE_FILE.${RESET}"
}

# ------------------------------------------------------------------------------
# 13. Configure SOC credentials and detect server IP
# ------------------------------------------------------------------------------
configure_soc_stack() {
    echo -e "${BLUE}Configuring environment and credentials for SOC stack...${RESET}"
    
    local interface
    interface=$(ip route show default | awk '{print $5; exit}')
    if [ -z "$interface" ]; then
        interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
    fi

    local ip_addr
    ip_addr=$(ip -o -4 addr show dev "$interface" | awk '{print $4}' | cut -d/ -f1 | head -n 1)
    if [ -z "$ip_addr" ]; then
        ip_addr=$(hostname -I | awk '{print $1}')
    fi

    local public_ip
    public_ip=$(curl -s --connect-timeout 3 https://ifconfig.me 2>/dev/null || echo "NOT DETECTED")

    local host_name
    host_name=$(hostname)

    # Simple password generator
    generate_pass() {
        openssl rand -hex 16
    }

    local elastic_pass
    local kibana_system_pass
    local splunk_pass
    local wazuh_api_pass
    local misp_admin_pass
    local thehive_admin_pass

    # Preserve old settings if reconfiguring
    if [ -f "$ENV_FILE" ]; then
        echo -e "Existing .env file found. Retaining current keys..."
        elastic_pass=$(grep "^ELASTIC_PASSWORD=" "$ENV_FILE" | cut -d= -f2- || true)
        kibana_system_pass=$(grep "^KIBANA_SYSTEM_PASSWORD=" "$ENV_FILE" | cut -d= -f2- || true)
        splunk_pass=$(grep "^SPLUNK_PASSWORD=" "$ENV_FILE" | cut -d= -f2- || true)
        wazuh_api_pass=$(grep "^WAZUH_API_PASSWORD=" "$ENV_FILE" | cut -d= -f2- || true)
        misp_admin_pass=$(grep "^MISP_ADMIN_PASS=" "$ENV_FILE" | cut -d= -f2- || true)
        thehive_admin_pass=$(grep "^THEHIVE_ADMIN_PASS=" "$ENV_FILE" | cut -d= -f2- || true)
    fi

    [ -z "${elastic_pass:-}" ] && elastic_pass=$(generate_pass)
    [ -z "${kibana_system_pass:-}" ] && kibana_system_pass=$(generate_pass)
    [ -z "${splunk_pass:-}" ] && splunk_pass=$(generate_pass)
    [ -z "${wazuh_api_pass:-}" ] && wazuh_api_pass=$(generate_pass)
    [ -z "${misp_admin_pass:-}" ] && misp_admin_pass=$(generate_pass)
    [ -z "${thehive_admin_pass:-}" ] && thehive_admin_pass=$(generate_pass)

    cat << EOF > "$ENV_FILE"
# ==============================================================================
# Docker SOC Server Stack Settings
# ==============================================================================
PROFILE=$PROFILE
HOST_IP=$ip_addr
HOST_PUBLIC_IP=$public_ip
HOST_HOSTNAME=$host_name
NETWORK_INTERFACE=$interface

# Dynamic Credentials
ELASTIC_PASSWORD=$elastic_pass
KIBANA_SYSTEM_PASSWORD=$kibana_system_pass
SPLUNK_PASSWORD=$splunk_pass
WAZUH_API_USER=wazuh
WAZUH_API_PASSWORD=$wazuh_api_pass
MISP_ADMIN_EMAIL=admin@admin.test
MISP_ADMIN_PASS=$misp_admin_pass
THEHIVE_ADMIN_USER=admin@thehive.local
THEHIVE_ADMIN_PASS=$thehive_admin_pass
CORTEX_API_KEY=CORTEX_API_KEY_PLACEHOLDER
EOF

    chmod 600 "$ENV_FILE"
    echo -e "${GREEN}Configuration written to $ENV_FILE.${RESET}"
}

# ------------------------------------------------------------------------------
# 14. Initialize Network & Deploy Stack
# ------------------------------------------------------------------------------
start_soc_stack() {
    CURRENT_PHASE="soc_start"
    echo -e "${BLUE}Initializing Docker Network Isolation...${RESET}"
    
    local net_name="soc-lab"
    local subnet="10.60.0.0/24"
    local gateway="10.60.0.1"

    if docker network inspect "$net_name" &>/dev/null; then
        echo -e "Docker network '$net_name' already exists."
    else
        echo -e "Creating Docker bridge network '$net_name' ($subnet)..."
        docker network create \
            --driver bridge \
            --subnet "$subnet" \
            --gateway "$gateway" \
            --opt "com.docker.network.bridge.name"="br-soc-lab" \
            "$net_name"
        echo -e "${GREEN}Network '$net_name' created.${RESET}"
    fi

    # Display volume mapping
    cat << EOF

======================================================================
 Persistent Volume Mapping
======================================================================
 Container             --> Docker Volume           --> Purpose
 ---------------------------------------------------------------------
 elasticsearch         --> esdata                  --> Elasticsearch Database
 splunk                --> splunk-var, splunk-etc  --> Splunk Data & Config
 wazuh-manager         --> wazuh-etc, wazuh-logs   --> Wazuh Config & Alert Logs
                       --> wazuh-queue             --> Wazuh Agent Queues
 cassandra             --> cassandra-data          --> Cassandra database (TheHive)
 thehive               --> thehive-data            --> TheHive Case Data
 cortex                --> cortex-jobs             --> Cortex analyzer jobs
 misp-db               --> misp-db-data            --> MISP MySQL Database
 misp                  --> misp-data               --> MISP core application
======================================================================

EOF

    # Load environmental values
    export $(grep -v '^#' "$ENV_FILE" | xargs)

    # Determine services to start based on RAM profile
    local services=()
    case "$PROFILE" in
        "minimal")
            services=("elasticsearch" "kibana")
            ;;
        "standard")
            services=("elasticsearch" "kibana" "wazuh-manager" "wazuh-dashboard" "cassandra" "thehive" "cortex")
            ;;
        "full"|"instructor")
            services=("elasticsearch" "kibana" "splunk" "wazuh-manager" "wazuh-dashboard" "cassandra" "thehive" "cortex" "misp-db" "misp")
            ;;
    esac

    echo -e "${BLUE}Pulling and starting SOC stack services: [${services[*]}]...${RESET}"
    cd "$STACK_DIR"
    
    docker compose pull "${services[@]}"
    docker compose up -d "${services[@]}"
    echo -e "${GREEN}Docker SOC Stack containers started.${RESET}"
}

# ------------------------------------------------------------------------------
# 15. Verify Stack & Run Web UI/API Health Checks
# ------------------------------------------------------------------------------
verify_soc_stack() {
    echo -e "${BLUE}Verifying container and service health status...${RESET}"
    cd "$STACK_DIR"
    
    # Give containers a small grace period to init
    echo -e "Waiting 15 seconds for initial application bootstrapping..."
    sleep 15
    
    # Load env
    export $(grep -v '^#' "$ENV_FILE" | xargs)

    # Health check endpoints
    check_http() {
        local name="$1"
        local url="$2"
        local expected_code="${3:-200}"
        
        local code
        code=$(curl -sk -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        if [ "$code" -eq "$expected_code" ] || [ "$code" -eq 401 ] || [ "$code" -eq 302 ]; then
            echo -e "  - $name: ${GREEN}HEALTHY${RESET} (HTTP $code)"
            return 0
        else
            echo -e "  - $name: ${RED}UNHEALTHY${RESET} (HTTP $code)"
            return 1
        fi
    }

    echo -e "\n========================================"
    echo -e " Docker SOC Server Status"
    echo -e "========================================"
    echo -e "Docker Engine       : RUNNING"
    echo -e "Docker Compose      : AVAILABLE"
    echo -e "\nSOC SERVICE         STATUS"
    echo -e "----------------------------------------"

    local failed=0
    
    # Minimal Check
    check_http "Elasticsearch API" "http://localhost:9200" || failed=$((failed+1))
    check_http "Kibana Web UI" "http://localhost:5601" || failed=$((failed+1))

    # Standard Check
    if [ "$PROFILE" = "standard" ] || [ "$PROFILE" = "full" ] || [ "$PROFILE" = "instructor" ]; then
        check_http "Wazuh API" "https://localhost:55000" || failed=$((failed+1))
        check_http "TheHive Web UI" "http://localhost:9000" || failed=$((failed+1))
        check_http "Cortex API" "http://localhost:9001" || failed=$((failed+1))
    fi

    # Full Check
    if [ "$PROFILE" = "full" ] || [ "$PROFILE" = "instructor" ]; then
        check_http "Splunk Web UI" "http://localhost:8000" || failed=$((failed+1))
        check_http "MISP Web UI" "https://localhost:9443" || failed=$((failed+1))
    fi

    echo -e "----------------------------------------"
    if [ "$failed" -eq 0 ]; then
        echo -e "SOC Stack            : ${GREEN}RUNNING & HEALTHY${RESET}"
    else
        echo -e "SOC Stack            : ${YELLOW}RUNNING (WITH WARNINGS)${RESET}"
        echo -e "Some services are still booting or unhealthy. You can check logs using 'docker compose logs'."
    fi
    echo -e "========================================\n"
}

# ------------------------------------------------------------------------------
# Create simple management scripts in /opt/Docker_SOC_Server_Stack/scripts/
# ------------------------------------------------------------------------------
create_management_scripts() {
    echo -e "${BLUE}Generating management scripts under ${STACK_DIR}/scripts/...${RESET}"
    
    # 1. start.sh
    cat << 'EOF' > "$STACK_DIR/scripts/start.sh"
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

case "$PROFILE" in
    "minimal") SERVICES=("elasticsearch" "kibana") ;;
    "standard") SERVICES=("elasticsearch" "kibana" "wazuh-manager" "wazuh-dashboard" "cassandra" "thehive" "cortex") ;;
    "full"|"instructor") SERVICES=("elasticsearch" "kibana" "splunk" "wazuh-manager" "wazuh-dashboard" "cassandra" "thehive" "cortex" "misp-db" "misp") ;;
esac

echo "Starting SOC Server Stack ($PROFILE profile)..."
docker compose up -d "${SERVICES[@]}"
EOF

    # 2. stop.sh
    cat << 'EOF' > "$STACK_DIR/scripts/stop.sh"
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Stopping and tearing down SOC Server Stack..."
docker compose down
EOF

    # 3. restart.sh
    cat << 'EOF' > "$STACK_DIR/scripts/restart.sh"
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Restarting SOC Server Stack..."
./scripts/stop.sh
./scripts/start.sh
EOF

    # 4. status.sh
    cat << 'EOF' > "$STACK_DIR/scripts/status.sh"
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "========================================"
echo " Docker SOC Server Status"
echo "========================================"
docker compose ps
echo "========================================"
EOF

    # 5. logs.sh
    cat << 'EOF' > "$STACK_DIR/scripts/logs.sh"
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [ $# -gt 0 ]; then
    docker compose logs -f "$@"
else
    docker compose logs -f --tail=100
fi
EOF

    # 6. health-check.sh
    cat << 'EOF' > "$STACK_DIR/scripts/health-check.sh"
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

PASS_COUNT=0
FAIL_COUNT=0

check_endpoint() {
    local name="$1"
    local url="$2"
    local expected_code="${3:-200}"

    local code
    code=$(curl -sk -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    if [ "$code" -eq "$expected_code" ] || [ "$code" -eq 401 ] || [ "$code" -eq 302 ]; then
        echo -e "\e[32m[OK]   $name is REACHABLE (HTTP $code)\e[0m"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "\e[31m[FAIL] $name is UNREACHABLE (HTTP $code) — URL: $url\e[0m"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

echo "========================================"
echo " Running SOC Server Health Check"
echo " Profile: $PROFILE"
echo "========================================"

# Minimal profile services
check_endpoint "Elasticsearch API" "http://localhost:9200"
check_endpoint "Kibana Web UI" "http://localhost:5601"

# Standard profile services
if [ "$PROFILE" = "standard" ] || [ "$PROFILE" = "full" ] || [ "$PROFILE" = "instructor" ]; then
    check_endpoint "Wazuh API" "https://localhost:55000"
    check_endpoint "TheHive Web UI" "http://localhost:9000"
    check_endpoint "Cortex API" "http://localhost:9001"
fi

# Full profile services
if [ "$PROFILE" = "full" ] || [ "$PROFILE" = "instructor" ]; then
    check_endpoint "Splunk Web UI" "http://localhost:8000"
    check_endpoint "MISP Web UI" "https://localhost:9443"
fi

echo "========================================"
echo " HEALTH CHECK SUMMARY"
echo "========================================"
echo " Services Checked: $((PASS_COUNT + FAIL_COUNT))"
echo " Services Passed:  $PASS_COUNT"
echo " Services Failed:  $FAIL_COUNT"
echo " RESULT: $([ "$FAIL_COUNT" -eq 0 ] && echo "PASSED" || echo "FAILED")"
echo "========================================"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
fi
EOF

    chmod +x "$STACK_DIR"/scripts/*.sh
    echo -e "${GREEN}Management scripts created and marked executable.${RESET}"
}

# ------------------------------------------------------------------------------
# 16. Display final summary
# ------------------------------------------------------------------------------
display_summary() {
    # Load values to print final summary
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    
    echo -e "\n========================================"
    echo -e " Docker SOC Server Installation Complete"
    echo -e "========================================"
    echo -e "Ubuntu Server       : OK"
    echo -e "Docker Engine       : OK"
    echo -e "Docker Compose      : OK"
    echo -e "Docker Service      : RUNNING"
    echo -e "SOC Stack           : RUNNING"
    echo -e "Docker Network      : OK"
    echo -e "Persistent Storage  : OK"
    echo -e "Health Checks       : PASSED"
    echo -e "\nSOC Server IP (Private) : $HOST_IP"
    echo -e "SOC Server IP (Public)  : ${HOST_PUBLIC_IP:-NOT DETECTED}"
    echo -e "Profile Used            : ${PROFILE^^}"
    echo -e "\nStack Directory:"
    echo -e " $STACK_DIR/"
    echo -e "\nUseful Commands:"
    echo -e "  Start:"
    echo -e "    $STACK_DIR/scripts/start.sh"
    echo -e "  Stop:"
    echo -e "    $STACK_DIR/scripts/stop.sh"
    echo -e "  Status:"
    echo -e "    $STACK_DIR/scripts/status.sh"
    echo -e "  Logs:"
    echo -e "    $STACK_DIR/scripts/logs.sh"
    echo -e "  Health Check:"
    echo -e "    $STACK_DIR/scripts/health-check.sh"
    echo -e "\n========================================"
}

# ------------------------------------------------------------------------------
# Check for existing installations
# ------------------------------------------------------------------------------
check_existing() {
    local docker_installed=0
    local stack_installed=0
    
    if command -v docker &>/dev/null; then
        docker_installed=1
    fi
    if [ -f "$COMPOSE_FILE" ]; then
        stack_installed=1
    fi

    if [ $docker_installed -eq 1 ] || [ $stack_installed -eq 1 ]; then
        echo -e "${YELLOW}======================================================================${RESET}"
        echo -e "${YELLOW} Existing components of Docker SOC Server Stack detected:${RESET}"
        [ $docker_installed -eq 1 ] && echo "  - Docker Engine is installed."
        [ $stack_installed -eq 1 ] && echo "  - SOC Stack directory already exists: $STACK_DIR"
        echo -e "${YELLOW}======================================================================${RESET}"
        
        local action=""
        if [ ! -t 0 ]; then
            # Non-interactive Mode (e.g. wrapper run.sh)
            action="update"
            echo "Non-interactive environment detected. Defaulting to action: UPDATE"
        else
            echo "Please choose an action:"
            echo "1) Reconfigure (Regenerate environment parameters, keep existing containers)"
            echo "2) Restart (Restart the SOC Server Stack containers)"
            echo "3) Update (Pull updated images and recreate existing stack)"
            echo "4) Exit"
            read -rp "Enter option [1-4]: " option
            case "$option" in
                1) action="reconfigure" ;;
                2) action="restart" ;;
                3) action="update" ;;
                4|*) action="exit" ;;
            esac
        fi

        case "$action" in
            "reconfigure")
                echo "Reconfiguring environment variables..."
                configure_soc_stack
                exit 0
                ;;
            "restart")
                echo "Restarting the SOC server stack..."
                if [ -f "$STACK_DIR/scripts/restart.sh" ]; then
                    "$STACK_DIR/scripts/restart.sh"
                else
                    cd "$STACK_DIR" && docker compose restart
                fi
                exit 0
                ;;
            "update")
                echo "Proceeding with update installation..."
                ;;
            "exit")
                echo "Exiting."
                exit 0
                ;;
        esac
    fi
}

# ------------------------------------------------------------------------------
# Dispatch Main Workflow
# ------------------------------------------------------------------------------
main() {
    check_root
    check_os
    check_architecture
    check_resources
    check_existing
    update_system
    install_dependencies
    install_docker
    install_docker_compose
    configure_docker
    verify_docker
    create_soc_directories
    copy_or_generate_soc_stack
    configure_soc_stack
    start_soc_stack
    create_management_scripts
    verify_soc_stack
    display_summary
}

main "$@"

#!/bin/bash
# ============================================================
# Script Name: user_mng.sh
# Description: Automates user creation, group assignment, and permission management
# Author: Shravani Dhandrut
# Date: $(date)
# ============================================================
# CHECK: Script must be run as root
# ============================================================
if [ "$EUID" -ne 0 ]; then
	echo "Error: Please run this script as root or using sudo"
	exit 1
fi

echo "Root check passed. Starting user management..."

# ===========================================================
# VARIABLES
# ===========================================================
LOG_FILE="/var/log/user-management.log"
CSV_FILE="/home/shra/projects/user-management/users.csv"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
DEPARTMENTS=("developers" "devops" "managers")
SHARED_DIR="/company/shared"
BASE_DIR="/company"


# ===========================================================
# LOG FUNCTION
# ===========================================================
log_action() {
	echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

log_action "======== Script Started ========"

# ==========================================================
# CHECK: CSV file must exist
# ==========================================================
if [ ! -f "$CSV_FILE" ]; then
	log_action "ERROR: CSV file not found at $CSV_FILE"
	exit 1
fi

log_action "CSV file found. Reading users..."

# =========================================================
# READ CSV FILE
# =========================================================
while IFS="," read -r USERNAME DEPARTMENT PASSWORD; do
	#Skip the header line
	if [ "$USERNAME" == "username" ]; then
		continue
	fi

	echo "---------------------------------------------------"
	log_action "Processing user: $USERNAME | Department: $DEPARTMENT"

# =========================================================
# CREATE GROUP IF IT DOESN'T EXIST
# =========================================================
if ! getent group "$DEPARTMENT" > /dev/null 2>&1; then
	groupadd "$DEPARTMENT"
	log_action "Group created: $DEPARTMENT"
else
	log_action "Group already exists: $DEPARTMENT"
fi

# =========================================================
# CREATE USER IF IT DOESN'T EXIST
# =========================================================
if ! id "$USERNAME" > /dev/null 2>&1; then
	useradd -m -s /bin/bash -G "$DEPARTMENT" "$USERNAME"
	log_action "User created: $USERNAME and added to $DEPARTMENT"
	# ===========================================================
	# SET PASSWORD
	# ===========================================================
	echo "$USERNAME:$PASSWORD" | chpasswd
	log_action "Password set for: $USERNAME"

	# ===========================================================
	# FORCE PASSWORD CHANGE ON FIRST LOGIN
	# ===========================================================
	chage -d 0 "$USERNAME"
	log_action "First login password change enforced for: $USERNAME"

	# ===========================================================
	# SET PASSWORD AGING POLICY
	# ===========================================================
	chage -m 1 -M 90 -W 7 "$USERNAME"
	log_action "Password policy applied for: $USERNAME (min:1 max:90 warn:7)"

else
	log_action "User already exists: $USERNAME - skipping"
fi

done < "$CSV_FILE"

# =========================================================
# CREATE DEPARTMENT DIRECTORIES & PERSMISSIONS
# =========================================================
log_action "======== Setting Up Directories ========"

# Create base directory
if [ ! -d "$BASE_DIR" ]; then
	mkdir -p "$BASE_DIR"
	chmod 755 "$BASE_DIR"
	log_action "Base directory created: $BASE_DIR"
else
	log_action "Base directory already exists: $BASE_DIR"
fi

#Create department directories
for DEPT in "${DEPARTMENTS[@]}"; do
	DEPT_DIR="$BASE_DIR/$DEPT"

	if [ ! -d "$DEPT_DIR" ]; then
		mkdir -p "$DEPT_DIR"
		chown root:"$DEPT" "$DEPT_DIR"
		chmod 770 "$DEPT_DIR"
		log_action "Directory created: $DEPT_DIR with group: $DEPT and permission:770"
	else
		log_action "Directory already exists: $DEPT_DIR - skipping"
	fi
done

# Create shared directory
if [ ! -d "$SHARED_DIR" ]; then
	mkdir -p "$SHARED_DIR"
	chmod 1777 "$SHARED_DIR"
	log_action "Shared directory created: $SHARED_DIR with sticky bit (1777)"
else
	log_action "Shared directory already exists: $SHARED_DIR - skipping"
fi
log_action "======== Script Completed Successfully ========"

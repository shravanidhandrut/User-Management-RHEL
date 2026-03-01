# Automated User & Permission Management System
### Built on RHEL 9 | Bash Scripting | Linux Administration

---

## 📌 Project Overview
This project automates the process of user provisioning, group management,
directory setup, and password policy enforcement on a RHEL 9 server.
It simulates a real enterprise environment where new employees are
onboarded automatically based on their department.

---

## 🏢 Project Scenario
A company has 3 departments: Developers, DevOps, and Managers.
When a new employee joins, the sysadmin simply adds their details
to a CSV file and runs the script — everything else is automated.

---

## ⚙️ Features
- Reads user data from a CSV input file
- Automatically creates Linux groups per department
- Creates user accounts with home directories
- Assigns users to their department groups
- Sets passwords automatically from CSV
- Forces password change on first login
- Applies enterprise password aging policy (min/max/warning)
- Creates department directories with strict permissions (770)
- Creates shared directory with sticky bit (1777)
- Validates duplicates — safe to run multiple times
- Logs every action with timestamps to /var/log/user-management.log

---

## 🛠️ Technologies Used
- RHEL 9 (Red Hat Enterprise Linux)
- Bash Scripting
- Linux User Management (useradd, usermod, userdel)
- Password Management (chpasswd, chage)
- File Permissions (chmod, chown)
- Linux Groups (groupadd, groupdel)
- VMware Workstation

---

## 📁 Project Structure
\```
user-management/
├── user_mng.sh       # Main automation script
├── users.csv         # Input file with user data
└── README.md         # Project documentation
\```

---

## 📄 CSV Format
\```
username,department,password
dev_alice,developers,Alice@1234
dev_bob,developers,Bob@1234
ops_john,devops,John@1234
mgr_sara,managers,Sara@1234
\```

---

## 🚀 How to Run

### Step 1 — Go to project directory
\```bash
cd ~/projects/user-management
\```

### Step 2 — Add users to CSV file
\```bash
vim users.csv
\```

### Step 3 — Run the script as root
\```bash
sudo bash user_mng.sh
\```

---

## 📂 Directory Structure Created
\```
/company/
├── developers/    (chmod 770 | group: developers)
├── devops/        (chmod 770 | group: devops)
├── managers/      (chmod 770 | group: managers)
└── shared/        (chmod 1777 | sticky bit | all users)
\```

---

## 🔐 Password Policy Applied
| Policy         | Value        |
|----------------|--------------|
| Minimum age    | 1 day        |
| Maximum age    | 90 days      |
| Warning period | 7 days       |
| First login    | Must change  |

---

## 📋 Log File
All actions are logged with timestamps to:
\```
/var/log/user-management.log
\```

---

## ✅ Testing Results
| Test Case                             | Result  |
|---------------------------------------|---------|
| New user creation                     | ✅ Pass |
| Duplicate user detection              | ✅ Pass |
| Password set from CSV                 | ✅ Pass |
| Forced password change on first login | ✅ Pass |
| Password aging policy applied         | ✅ Pass |
| Department directory created          | ✅ Pass |
| Access denied to other departments    | ✅ Pass |
| Shared directory accessible by all    | ✅ Pass |
| Log file captures all actions         | ✅ Pass |

---

## 👤 Author
**Shravani Dhandrut**
RHCSA | Linux Administration
GitHub: https://github.com/shravanidhandrut

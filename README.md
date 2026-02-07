STEP 03 – ACTIVE DIRECTORY AUTOMATION (OUs, USERS, GROUPS)

OVERVIEW
In this step, I automated the creation of a complete Active Directory structure using PowerShell. This included creating Organizational Units (OUs), security groups, user accounts, and assigning users to groups based on their department. All objects were generated from a CSV file, simulating a realistic enterprise onboarding workflow. Verification was completed using Active Directory Users and Computers (ADUC).

FOLDER STRUCTURE
lab-step-03-active-directory-automation
│
├── README (this document)
│
├── scripts
│     Create-ADStructure.ps1
│     users.csv
│
└── screenshots
      01_lab_ou_structure.png
      02_sales_ou_users.png
      03_hr_ou_users.png
      04_it_ou_users.png
      05_admins_ou_users.png
      06_sales_users_group.png
      07_hr_users_group.png
      08_helpdesk_tier1_group.png
      09_workstation_admins_group.png
      10_it_admins_group.png
      11_script_execution.png

ORGANIZATIONAL UNIT STRUCTURE
The following OUs were created under the root LAB OU:

Admins
IT
HR
Sales
Workstations
Servers
ServiceAccounts

Screenshot: LAB OU Structure
Caption: The full OU hierarchy created under the LAB root OU.
File: 01_lab_ou_structure.png

USERS IN EACH OU
Users were created from a CSV file containing FirstName, LastName, Department, and Username. Each user was automatically placed into the correct OU.

Screenshot: Sales OU
Caption: Sales users created and placed in the Sales OU.
File: 02_sales_ou_users.png

Screenshot: HR OU
Caption: HR users created and placed in the HR OU.
File: 03_hr_ou_users.png

Screenshot: IT OU
Caption: IT users created and placed in the IT OU.
File: 04_it_ou_users.png

Screenshot: Admins OU
Caption: Admin users created and placed in the Admins OU.
File: 05_admins_ou_users.png

SECURITY GROUPS
The following security groups were created and placed inside their respective OUs:

Admins OU: IT_Admins
IT OU: Helpdesk_Tier1, Workstation_Admins
HR OU: HR_Users
Sales OU: Sales_Users

GROUP MEMBERSHIP VERIFICATION
Users were automatically added to groups based on their department.

Screenshot: Sales_Users Group
Caption: Members tab showing all Sales users assigned to the Sales_Users group.
File: 06_sales_users_group.png

Screenshot: HR_Users Group
Caption: Members tab showing all HR users assigned to the HR_Users group.
File: 07_hr_users_group.png

Screenshot: Helpdesk_Tier1 Group
Caption: Members tab showing IT users assigned to the Helpdesk_Tier1 group.
File: 08_helpdesk_tier1_group.png

Screenshot: Workstation_Admins Group
Caption: Members tab showing Admins and IT users assigned to the Workstation_Admins group.
File: 09_workstation_admins_group.png

Screenshot: IT_Admins Group
Caption: Members tab showing Admins and IT users assigned to the IT_Admins group.
File: 10_it_admins_group.png

AUTOMATION SCRIPTS
The scripts used in this step are located in the scripts folder:

Create-ADStructure.ps1
users.csv

These scripts automate:
– OU creation
– Group creation
– User creation
– Group membership assignment
– CSV-driven provisioning
– Idempotent logic (safe to re-run without duplicates)

SCRIPT EXECUTION
Screenshot: Script Execution
Caption: PowerShell output showing the automation script running successfully.
File: 11_script_execution.png

REFLECTION
This step reinforced several important concepts in enterprise Active Directory management:

• Data-driven automation is essential for scalable user provisioning.
• A clean and consistent OU structure makes administration and GPO targeting easier.
• Role-based access control (RBAC) is effectively implemented using security groups.
• Idempotent scripting ensures the environment can be rebuilt or updated safely.
• Verification using ADUC is critical to confirm automation results.

This workflow mirrors real-world IT onboarding processes and demonstrates the ability to automate and validate an entire AD structure from scratch.

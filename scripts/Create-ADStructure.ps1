Import-Module ActiveDirectory

# ===== 1. Create OU structure =====
$rootOU = "OU=LAB,DC=lab,DC=local"

# Create root OU
if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=LAB)" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "LAB" -Path "DC=lab,DC=local"
}

$childOUs = @(
    "Admins",
    "IT",
    "HR",
    "Sales",
    "Workstations",
    "Servers",
    "ServiceAccounts"
)

foreach ($ou in $childOUs) {
    $ouPath = "OU=$ou,$rootOU"
    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$ou)" -SearchBase $rootOU -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -Path $rootOU
    }
}

# ===== 2. Create security groups =====
$groups = @(
    @{ Name = "IT_Admins"; OU = "Admins" },
    @{ Name = "HR_Users"; OU = "HR" },
    @{ Name = "Sales_Users"; OU = "Sales" },
    @{ Name = "Helpdesk_Tier1"; OU = "IT" },
    @{ Name = "Workstation_Admins"; OU = "IT" }
)

foreach ($g in $groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($g.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $g.Name `
                    -Path "OU=$($g.OU),$rootOU" `
                    -GroupScope Global `
                    -GroupCategory Security
    }
}

# ===== 3. Import users from CSV and create accounts =====
$csvPath = "\\VBOXSVR\VM_Screenshots\users.csv"   # <-- CHANGE THIS to your actual shared folder path

if (-not (Test-Path $csvPath)) {
    Write-Error "CSV file not found at $csvPath"
    exit
}

$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    $ouName = $user.Department
    $ouPath = "OU=$ouName,$rootOU"

    $sam = $user.Username
    $upn = "$sam@lab.local"
    $displayName = "$($user.FirstName) $($user.LastName)"

    if (-not (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue)) {
        New-ADUser `
            -Name $displayName `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -SamAccountName $sam `
            -UserPrincipalName $upn `
            -Path $ouPath `
            -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -Description "$($user.Department) User"
    }
}

# ===== 4. Add users to groups based on department =====
foreach ($user in $users) {
    $sam = $user.Username
    $adUser = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue
    if (-not $adUser) { continue }

    switch ($user.Department) {
        "IT" {
            Add-ADGroupMember -Identity "IT_Admins" -Members $adUser -ErrorAction SilentlyContinue
            Add-ADGroupMember -Identity "Helpdesk_Tier1" -Members $adUser -ErrorAction SilentlyContinue
        }
        "HR" {
            Add-ADGroupMember -Identity "HR_Users" -Members $adUser -ErrorAction SilentlyContinue
        }
        "Sales" {
            Add-ADGroupMember -Identity "Sales_Users" -Members $adUser -ErrorAction SilentlyContinue
        }
        "Admins" {
            Add-ADGroupMember -Identity "IT_Admins" -Members $adUser -ErrorAction SilentlyContinue
            Add-ADGroupMember -Identity "Workstation_Admins" -Members $adUser -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "OU structure, groups, users, and memberships created successfully." -ForegroundColor Green

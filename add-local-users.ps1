# Define the username and the group
$username = "" # Enter username here
$fullname = "" # Enter full name here
$description = "" # Enter description here
$password = "" | ConvertTo-SecureString -AsPlainText -Force # Enter password here
$group = "" # Enter group name here

# Check if the user already exists
if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
    Write-Host "User $username already exists."
} else {
    # Create a new local user
    New-LocalUser -Name $username -Password $password -FullName $fullname -Description $description
    Write-Host "User $username created."
}

# Add the user to the specified group
Add-LocalGroupMember -Group $group -Member $username
Write-Host "User $username added to $group group."

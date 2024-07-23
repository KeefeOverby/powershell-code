# Read the JSON file
$jsonFilePath = "C:\path\to\your\users.json" # Change file path
$users = Get-Content $jsonFilePath | ConvertFrom-Json

foreach ($user in $users) {
    $username = $user.Username
    $fullName = $user.FullName
    $description = $user.Description
    $group = $user.Group
    $password = $user.Password | ConvertTo-SecureString -AsPlainText -Force

    # Check if the user already exists
    if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        Write-Host "User $username already exists."
    } else {
        # Create a new local user
        New-LocalUser -Name $username -Password $password -FullName $fullName -Description $description
        Write-Host "User $username created."
    }

    # Add the user to the Administrators group (or any other group you specify)
    Add-LocalGroupMember -Group $group -Member $username
    Write-Host "User $username added to Administrators group."
}

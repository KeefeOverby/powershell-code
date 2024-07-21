# Import the Active Directory module
Import-Module ActiveDirectory

# Define variables
$groupName = "infosec_team"  # Replace with your group name
$targetOU = "OU=IT,DC=keefeoverby,DC=com"  # Replace with the target OU distinguished name

# Get the group object
$group = Get-ADGroup -Identity $groupName

if ($group) {
    Write-Output "Found group: $groupName"

    # Move the group to the target OU
    try {
        Move-ADObject -Identity $group.DistinguishedName -TargetPath $targetOU
        Write-Output "Moved group $groupName to $targetOU"
    } catch {
        Write-Error "Failed to move group $groupName"
    }

    # Get group members
    $members = Get-ADGroupMember -Identity $groupName -Recursive

    foreach ($member in $members) {
        # Move user objects to the target OU
        if ($member.objectClass -eq "user") {
            try {
                Move-ADObject -Identity $member.DistinguishedName -TargetPath $targetOU
                Write-Output "Moved user $($member.SamAccountName) to $targetOU"
            } catch {
                Write-Error "Failed to move user $($member.SamAccountName)"
            }
        } else {
            Write-Output "Skipping non-user member: $($member.SamAccountName)"
        }
    }
} else {
    Write-Error "Group $groupName not found."
}

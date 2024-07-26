# Variables
$domainName = "keefeoverby.com"
$netbiosName = "KEEFEOVERBY"
$safeModeAdminPassword = "" # Secure this properly
$logFile = "C:\log-files\ADDS_Install_Log.txt"

# Function to log messages
function Send-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] - $message"
    Write-Output $logEntry
    Add-Content -Path $logFile -Value $logEntry
}

# Start Logging
Send-Message "Starting AD DS and DNS installation script."

# Install AD DS and DNS Server roles
try {
    Send-Message "Installing AD DS role."
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
    Send-Message "AD DS role installed successfully."

    Send-Message "Installing DNS Server role."
    Install-WindowsFeature -Name DNS -IncludeManagementTools -ErrorAction Stop
    Send-Message "DNS Server role installed successfully."
} catch {
    Send-Message "Error installing Windows features: $_" "ERROR"
    throw $_
}

# Import AD DS Deployment module
try {
    Send-Message "Importing AD DS Deployment module."
    Import-Module ADDSDeployment -ErrorAction Stop
    Send-Message "AD DS Deployment module imported successfully."
} catch {
    Send-Message "Error importing AD DS Deployment module: $_" "ERROR"
    throw $_
}

# Install a new AD forest
try {
    Send-Message "Installing new AD forest with domain name $domainName."
    Install-ADDSForest `
        -DomainName $domainName `
        -DomainNetbiosName $netbiosName `
        -SafeModeAdministratorPassword (ConvertTo-SecureString $safeModeAdminPassword -AsPlainText -Force) `
        -InstallDNS `
        -Force `
        -NoRebootOnCompletion -ErrorAction Stop
    Send-Message "AD forest installation completed successfully."
} catch {
    Send-Message "Error installing AD forest: $_" "ERROR"
    throw $_
}

# Reboot the server to complete installation
try {
    Send-Message "Rebooting the server to complete installation."
    Restart-Computer -Force -ErrorAction Stop
} catch {
    Send-Message "Error rebooting the server: $_" "ERROR"
    throw $_
}

# Final log message
Send-Message "AD DS and DNS installation script completed."

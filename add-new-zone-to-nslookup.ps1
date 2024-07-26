# Variables
$zoneName = "2.0.10.in-addr.arpa"
$ipAddress = "10.0.2.5"
$ptrRecordName = "5"
$ptrDomainName = "keefeoverby.com"
$logFile = "C:\log-files\DNS_Zone_Add_Log.txt"

# Log function
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

# Start logging
Send-Message "Starting DNS zone creation and PTR record addition script."

# Add new DNS zone
try {
    Send-Message "Creating new DNS zone: $zoneName."
    Add-DnsServerPrimaryZone -Name $zoneName -ReplicationScope "Domain" -ErrorAction Stop
    Send-Message "DNS zone $zoneName created successfully."
} catch {
    Send-Message "Error creating DNS zone: $_" "ERROR"
    throw $_
}

# Add PTR record
try {
    Send-Message "Adding PTR record for IP $ipAddress pointing to $ptrDomainName."
    Add-DnsServerResourceRecordPtr -ZoneName $zoneName -Name $ptrRecordName -PtrDomainName $ptrDomainName -ErrorAction Stop
    Send-Message "PTR record added successfully."
} catch {
    Send-Message "Error adding PTR record: $_" "ERROR"
    throw $_
}

# Final log message
Send-Message "DNS zone creation and PTR record addition script completed."

# Copy the XML file
Copy-Item ".\DisconnectAzureVPNConnection.xml" "C:\IT Files\scripts"

# Register a new Scheduled Task using the XML
Register-ScheduledTask -xml (Get-Content "C:\IT Files\scripts\DisconnectAzureVPNConnection.xml" | Out-String) -TaskName "DisconnectAzureVPNConnection" -TaskPath "\"

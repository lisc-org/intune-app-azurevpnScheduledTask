$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like "DisconnectAzureVPNConnection"}

if($taskExists) {
  Write-Host "Success"
  Exit 0
} else {
  Exit 1
}

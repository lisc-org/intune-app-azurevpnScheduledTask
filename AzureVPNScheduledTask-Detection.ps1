# Start logging
$logFolder = Join-Path (Join-Path (Join-Path $ENV:SystemDrive "IT Files") "logs") "Intune-PowerShell";
$scriptName = ([System.IO.Path]::GetFileNameWithoutExtension($(Split-Path $script:MyInvocation.MyCommand.Path -Leaf)))
$logPath = Join-Path $logFolder ((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH-mm-ss-fffZ') + "_" + $scriptName + ".log");
Start-Transcript -Append -Force -Path $logPath;

# Force 64-bit if on a 64-bit OS
if ($PSHOME -like "*SysWOW64*" -and [System.Environment]::Is64BitOperatingSystem) {
    Write-Warning "Restarting this script under 64-bit Windows PowerShell.";
    Stop-Transcript;

    & (Join-Path ($PSHOME -replace "SysWOW64", "SysNative") powershell.exe) -File (Join-Path $PSScriptRoot $MyInvocation.MyCommand) @args;

    # Exit 32-bit script.
    Exit $LastExitCode;
};

# Start log cleanup
Write-Host "Looking for old log files";
$oldLogFiles = @(Get-ChildItem $logFolder | Where-Object LastWriteTime -lt (Get-Date).AddDays(-7));
if ($oldLogFiles.Length -ne 0) {
    Write-Host "Found old log files:"

    $oldLogFiles | ForEach-Object -Process {
        if ($_.Directory -like "*\IT Files\logs\Intune-PowerShell") {
            Write-Host "`t$($_.FullName)";
            Remove-Item -Path $_.FullName;
        };
    };

    Write-Host "Removed old log files"
};

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like "DisconnectAzureVPNConnection"}

if($taskExists) {
  Write-Output "DisconnectAzureVPNConnection Scheduled Task Found"
  $taskExists
} else {
  Throw "DisconnectAzureVPNConnection Scheduled Task not found"
}

Stop-Transcript;
Exit;
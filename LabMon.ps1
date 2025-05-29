# Load Windows Forms assembly for file picker
Add-Type -AssemblyName System.Windows.Forms

# Open file dialog to select the LabVIEW log file
$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
$openFileDialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*"
$openFileDialog.Title = "Select LabVIEW Log File"

if ($openFileDialog.ShowDialog() -eq "OK") {
    $logFile = $openFileDialog.FileName
    Write-Host "Selected Log File: $logFile"
} else {
    Write-Host "No file selected. Exiting..."
    exit
}

# Monitoring and Email Settings
$maxAgeSeconds = 60
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$smtpUser = "abcd@gmail.com"
$smtpPass = "qwiztxixczrpvbnl"
$to = "efgh@ualberta.ca"
$from = $smtpUser
$subject = "WARNING from LabMon"
$bodyTemplate = @"
Dear Operator, 

Please be informed that the LabVIEW application has stopped responding (Error in data logging).

Please check the LabVIEW application and system status immediately.

Regards,
LabMon (LabVIEW Monitor) System
"@

# Function to send email
function Send-WarningEmail {
    $message = New-Object System.Net.Mail.MailMessage $from, $to, $subject, $bodyTemplate
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)
    $smtp.Send($message)
    Write-Host "Warning email sent."
}

# Continuous monitoring loop
while ($true) {
    if (Test-Path $logFile) {
        $lastWrite = (Get-Item $logFile).LastWriteTime
        $now = Get-Date
        $age = ($now - $lastWrite).TotalSeconds

        if ($age -gt $maxAgeSeconds) {
            Write-Host "Log file has not been updated in the last $maxAgeSeconds seconds. Sending warning email..."
            Send-WarningEmail
            Start-Sleep -Seconds 15
            Send-WarningEmail
            break
        } else {
            Write-Host "Log file is up-to-date ($age seconds ago). All good."
        }
    } else {
        Write-Host "Log file not found. Sending warning email..."
        Send-WarningEmail
        break
    }

    Start-Sleep -Seconds 120
}

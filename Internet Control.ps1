Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Internet Access Control"
$form.Size = New-Object System.Drawing.Size(400,450)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Title label
$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Location = New-Object System.Drawing.Point(20,20)
$labelTitle.Size = New-Object System.Drawing.Size(350,30)
$labelTitle.Text = "Internet Access Control"
$labelTitle.Font = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($labelTitle)

# Status label
$labelStatus = New-Object System.Windows.Forms.Label
$labelStatus.Location = New-Object System.Drawing.Point(20,60)
$labelStatus.Size = New-Object System.Drawing.Size(350,20)
$labelStatus.Text = "Current status: Normal internet access"
$form.Controls.Add($labelStatus)

# Buttons
$buttonBlockAll = New-Object System.Windows.Forms.Button
$buttonBlockAll.Location = New-Object System.Drawing.Point(20,100)
$buttonBlockAll.Size = New-Object System.Drawing.Size(350,30)
$buttonBlockAll.Text = "1. Block ALL Internet Access"
$buttonBlockAll.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show(
        "WARNING: This will block ALL internet access including Windows system processes!`n`nContinue?",
        "Confirm", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    if ($result -eq "Yes") {
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c internet_control.bat 1" -Verb RunAs -Wait
        $labelStatus.Text = "Current status: ALL internet blocked"
    }
})
$form.Controls.Add($buttonBlockAll)

$buttonAddApp = New-Object System.Windows.Forms.Button
$buttonAddApp.Location = New-Object System.Drawing.Point(20,140)
$buttonAddApp.Size = New-Object System.Drawing.Size(350,30)
$buttonAddApp.Text = "2. Add Application to Allowed List"
$buttonAddApp.Add_Click({
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "Executable files (*.exe)|*.exe|All files (*.*)|*.*"
    $dialog.Title = "Select Application to Allow"
    
    if ($dialog.ShowDialog() -eq "OK") {
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c internet_control.bat 2", $dialog.FileName -Verb RunAs -Wait
        $labelStatus.Text = "Current status: Application added to allowed list"
    }
})
$form.Controls.Add($buttonAddApp)

$buttonRemoveApp = New-Object System.Windows.Forms.Button
$buttonRemoveApp.Location = New-Object System.Drawing.Point(20,180)
$buttonRemoveApp.Size = New-Object System.Drawing.Size(350,30)
$buttonRemoveApp.Text = "3. Remove Application from Allowed List"
$buttonRemoveApp.Add_Click({
    $rules = & cmd /c "netsh advfirewall firewall show rule dir=out | findstr `"Allow.*exe`""
    $selectedRule = [System.Windows.Forms.MessageBox]::Show(
        "Current rules:`n`n$rules`n`nPlease note the exact rule name to remove, then click OK to continue.",
        "Current Rules", 
        [System.Windows.Forms.MessageBoxButtons]::OKCancel,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    if ($selectedRule -eq "OK") {
        $ruleName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the exact rule name to remove:", "Remove Rule")
        if ($ruleName) {
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c internet_control.bat 3", $ruleName -Verb RunAs -Wait
            $labelStatus.Text = "Current status: Application removed from allowed list"
        }
    }
})
$form.Controls.Add($buttonRemoveApp)

$buttonRestore = New-Object System.Windows.Forms.Button
$buttonRestore.Location = New-Object System.Drawing.Point(20,220)
$buttonRestore.Size = New-Object System.Drawing.Size(350,30)
$buttonRestore.Text = "4. Restore Normal Internet Access"
$buttonRestore.Add_Click({
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c internet_control.bat 4" -Verb RunAs -Wait
    $labelStatus.Text = "Current status: Normal internet access"
})
$form.Controls.Add($buttonRestore)

$buttonViewRules = New-Object System.Windows.Forms.Button
$buttonViewRules.Location = New-Object System.Drawing.Point(20,260)
$buttonViewRules.Size = New-Object System.Drawing.Size(350,30)
$buttonViewRules.Text = "5. View Current Firewall Rules"
$buttonViewRules.Add_Click({
    $rules = & cmd /c "netsh advfirewall firewall show rule dir=out"
    [System.Windows.Forms.MessageBox]::Show($rules, "Current Firewall Rules")
})
$form.Controls.Add($buttonViewRules)

$buttonWindowsOnly = New-Object System.Windows.Forms.Button
$buttonWindowsOnly.Location = New-Object System.Drawing.Point(20,300)
$buttonWindowsOnly.Size = New-Object System.Drawing.Size(350,30)
$buttonWindowsOnly.Text = "6. Allow Essential Windows Services Only"
$buttonWindowsOnly.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show(
        "This will block all internet access except essential Windows services. Continue?",
        "Confirm", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    if ($result -eq "Yes") {
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c internet_control.bat 6" -Verb RunAs -Wait
        $labelStatus.Text = "Current status: Only Windows services allowed"
    }
})
$form.Controls.Add($buttonWindowsOnly)

$buttonShortcut = New-Object System.Windows.Forms.Button
$buttonShortcut.Location = New-Object System.Drawing.Point(20,340)
$buttonShortcut.Size = New-Object System.Drawing.Size(350,30)
$buttonShortcut.Text = "7. Create Desktop Shortcut"
$buttonShortcut.Add_Click({
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c internet_control.bat 7" -Verb RunAs -Wait
    [System.Windows.Forms.MessageBox]::Show("Shortcut created on desktop!", "Success")
})
$form.Controls.Add($buttonShortcut)

$buttonExit = New-Object System.Windows.Forms.Button
$buttonExit.Location = New-Object System.Drawing.Point(20,380)
$buttonExit.Size = New-Object System.Drawing.Size(350,30)
$buttonExit.Text = "8. Exit"
$buttonExit.Add_Click({ $form.Close() })
$form.Controls.Add($buttonExit)

# Show the form
[void]$form.ShowDialog()
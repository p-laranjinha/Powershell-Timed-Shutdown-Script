Add-Type -assembly System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Shutdown Timer'
$form.Width = 370
$form.Height = 90
$form.FormBorderStyle = 'FixedDialog';

$label = New-Object System.Windows.Forms.Label
$label.Text = "Minutes:"
$label.Location  = New-Object System.Drawing.Point(10,12)
$label.AutoSize = $true
$form.Controls.Add($label)

$numbox = New-Object System.Windows.Forms.NumericUpDown
$numbox.Maximum = [int]::MaxValue;
$numbox.Width = 70
$numbox.Location = New-Object System.Drawing.Point(70,10)
$form.Controls.Add($numbox)

$startbutton = New-Object System.Windows.Forms.Button
$startbutton.Text = "Start Timer"
$startbutton.Width = 90
$startbutton.Location = New-Object System.Drawing.Point(150,10)
$form.Controls.Add($startbutton)

$stopbutton = New-Object System.Windows.Forms.Button
$stopbutton.Text = "Stop Timer"
$stopbutton.Width = 90
$stopbutton.Location = New-Object System.Drawing.Point(250,10)
$form.Controls.Add($stopbutton)

$taskname = "Timed Shutdown"
$global:balloon = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$balloon.BalloonTipTitle = $taskname

$startbutton.Add_Click({
    $time = (Get-Date).AddMinutes($numbox.Value)
    $taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument 'Stop-Computer -Force'
    $taskTrigger = New-ScheduledTaskTrigger -Once -At $time
    Register-ScheduledTask -TaskName $taskname -Action $taskAction -Trigger $taskTrigger -Description "Computer will shutdown on $time"

    $balloon.BalloonTipText = "Computer will shutdown on $time."
    $balloon.Visible = $true
    $balloon.ShowBalloonTip(5000)
})

$stopbutton.Add_Click({
    if (Get-ScheduledTask | Where-Object {$_.TaskName -like $taskname }) {
        Unregister-ScheduledTask -TaskPath '\' -TaskName $taskname -Confirm:$false
        if (!(Get-ScheduledTask | Where-Object {$_.TaskName -like $taskname })) {
            $balloon.BalloonTipText = "Timer has been cancelled."
            $balloon.Visible = $true
            $balloon.ShowBalloonTip(3000)
        } else {
            $balloon.BalloonTipText = "Timer could not be cancelled."
            $balloon.Visible = $true
            $balloon.ShowBalloonTip(3000)
        }
    }
})

$form.ShowDialog()
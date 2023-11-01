Add-Type -assembly System.Windows.Forms

function ShowNotification($title, $text) {
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -id $pid).Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $balloon.BalloonTipTitle = $title
    $balloon.BalloonTipText = $text
    $balloon.Visible = $true
    $balloon.ShowBalloonTip(3000)
}

function CancelTimer {
    if (Get-ScheduledTask | Where-Object { $_.TaskName -like $taskname }) {
        Unregister-ScheduledTask -TaskPath '\' -TaskName $taskname -Confirm:$false
        if (!(Get-ScheduledTask | Where-Object { $_.TaskName -like $taskname })) {
            ShowNotification $taskname "Timer has been cancelled."
        }
        else {
            ShowNotification $taskname "ERROR: Timer could not be cancelled."
        }
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Shutdown Timer'
$form.Width = 370
$form.Height = 90
$form.FormBorderStyle = 'FixedDialog';

$label = New-Object System.Windows.Forms.Label
$label.Text = "Minutes:"
$label.Location = New-Object System.Drawing.Point(10, 12)
$label.AutoSize = $true
$form.Controls.Add($label)

$numbox = New-Object System.Windows.Forms.NumericUpDown
$numbox.Value = 60
$numbox.Maximum = [int]::MaxValue;
$numbox.Width = 70
$numbox.Location = New-Object System.Drawing.Point(70, 10)
$form.Controls.Add($numbox)

$startbutton = New-Object System.Windows.Forms.Button
$startbutton.Text = "Start Timer"
$startbutton.Width = 90
$startbutton.Location = New-Object System.Drawing.Point(150, 10)
$form.Controls.Add($startbutton)

$stopbutton = New-Object System.Windows.Forms.Button
$stopbutton.Text = "Stop Timer"
$stopbutton.Width = 90
$stopbutton.Location = New-Object System.Drawing.Point(250, 10)
$form.Controls.Add($stopbutton)

$taskname = "Timed Shutdown"

$startbutton.Add_Click({
        CancelTimer

        $time = (Get-Date).AddMinutes($numbox.Value)
        $taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument 'Stop-Computer -Force'
        $taskTrigger = New-ScheduledTaskTrigger -Once -At $time
        Register-ScheduledTask -TaskName $taskname -Action $taskAction -Trigger $taskTrigger -Description "Computer will shutdown on $time"

        ShowNotification $taskname "Computer will shutdown on $time."
    })

$stopbutton.Add_Click({
        CancelTimer
    })

$form.ShowDialog()
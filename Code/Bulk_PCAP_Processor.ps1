Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$form = New-Object Windows.Forms.Form
$form.Text = "Bulk PCAP Processor"
$form.Size = New-Object Drawing.Size(400, 400)

# Create labels
$labelFolder = New-Object Windows.Forms.Label
$labelFolder.Text = "PCAP file location:"
$labelFolder.Location = New-Object Drawing.Point(20, 20)

$labelOutput = New-Object Windows.Forms.Label
$labelOutput.Text = "Output CSV file:"
$labelOutput.Location = New-Object Drawing.Point(20, 60)

$labelProtocols = New-Object Windows.Forms.Label
$labelProtocols.Text = "Protocol Filter:"
$labelProtocols.Location = New-Object Drawing.Point(20, 100)

$labelIP = New-Object Windows.Forms.Label
$labelIP.Text = "IP Filter:"
$labelIP.Location = New-Object Drawing.Point(20, 140)

# Create textboxes and drop-down lists
$textBoxFolder = New-Object Windows.Forms.TextBox
$textBoxFolder.Location = New-Object Drawing.Point(20, 40)
$textBoxFolder.Size = New-Object Drawing.Size(300, 20)

$textBoxOutput = New-Object Windows.Forms.TextBox
$textBoxOutput.Location = New-Object Drawing.Point(20, 80)
$textBoxOutput.Size = New-Object Drawing.Size(300, 20)

$comboBoxProtocols = New-Object Windows.Forms.ComboBox
$comboBoxProtocols.Location = New-Object Drawing.Point(20, 120)
$comboBoxProtocols.Size = New-Object Drawing.Size(300, 20)
$comboBoxProtocols.Items.AddRange(@("HTTP", "TCP", "UDP", "DNS", "ICMP", ""))

$textBoxIP = New-Object Windows.Forms.TextBox
$textBoxIP.Location = New-Object Drawing.Point(20, 160)
$textBoxIP.Size = New-Object Drawing.Size(300, 20)

# Create buttons to open file and folder dialogs
$buttonFolder = New-Object Windows.Forms.Button
$buttonFolder.Text = "Browse"
$buttonFolder.Location = New-Object Drawing.Point(330, 40)

$buttonOutput = New-Object Windows.Forms.Button
$buttonOutput.Text = "Browse"
$buttonOutput.Location = New-Object Drawing.Point(330, 80)

# Function to handle folder dialog
$buttonFolder.Add_Click({
    $folderDialog = New-Object Windows.Forms.FolderBrowserDialog
    $result = $folderDialog.ShowDialog()
    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        $selectedFolder = $folderDialog.SelectedPath
        $textBoxFolder.Text = $selectedFolder
    }
})

# Function to handle file dialog for output file
$buttonOutput.Add_Click({
    $fileDialog = New-Object Windows.Forms.SaveFileDialog
    $fileDialog.Filter = "CSV Files (*.csv)|*.csv"
    $result = $fileDialog.ShowDialog()
    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        $selectedOutput = $fileDialog.FileName
        $textBoxOutput.Text = $selectedOutput
    }
})

# Create OK button
$buttonOK = New-Object Windows.Forms.Button
$buttonOK.Text = "OK"
$buttonOK.Location = New-Object Drawing.Point(150, 300)
$buttonOK.DialogResult = [Windows.Forms.DialogResult]::OK

# Create Cancel button
$buttonCancel = New-Object Windows.Forms.Button
$buttonCancel.Text = "Cancel"
$buttonCancel.Location = New-Object Drawing.Point(250, 300)
$buttonCancel.DialogResult = [Windows.Forms.DialogResult]::Cancel

# Add controls to the form
$form.Controls.Add($labelFolder)
$form.Controls.Add($textBoxFolder)
$form.Controls.Add($buttonFolder)

$form.Controls.Add($labelOutput)
$form.Controls.Add($textBoxOutput)
$form.Controls.Add($buttonOutput)

$form.Controls.Add($labelProtocols)
$form.Controls.Add($comboBoxProtocols)

$form.Controls.Add($labelIP)
$form.Controls.Add($textBoxIP)

$form.Controls.Add($buttonOK)
$form.Controls.Add($buttonCancel)

# Show the form
$result = $form.ShowDialog()

# Check which button was clicked
if ($result -eq [Windows.Forms.DialogResult]::OK) {
    $folder = $textBoxFolder.Text
    $output_file = $textBoxOutput.Text
    $prot = $comboBoxProtocols.Text.ToLower()
    $ip = $textBoxIP.Text

    # User Interface showing the user the output location of the files
    Write-Host "-- Analyzing Your Files --"
    Write-Host "Your results will be saved in a CSV File here --> $output_file"

    # User input required for this section
    $ipFilter = ""
    if ($ip -ne "") {
        $ipFilter = "ip.addr==" + $ip
        if ($prot -ne "") {
            $ipFilter = " && " + $ipFilter
        }
    }

    # Make the tshark variable your install location for Wireshark\tshark"
    $tshark = "C:\Program Files\Wireshark\tshark"

    # For loop to go through each object, and run the tshark program and options against that file.
    # tshark options can be customized, but MOST prevalent options are preloaded.
    # The $i=0 allows for cleaner formatting in the .csv file in Notepad
    # as it creates a blank line, then tells you the next file you are analyzing
    # then another blank line for easier interpretation of the results.

    $i = 0

    Get-ChildItem $folder | ForEach-Object {
        if ($i -ne 0) {
            Add-Content -Path $output_file -Value "`n$($_.FullName)`n"
        }
        $i++
        Write-Host $_
        & $tshark -r $_.FullName -T fields -e frame.number -e frame.time -e _ws.col.Protocol `
        -e ip.src -e ip.dst -e _ws.col.Length -e _ws.col.Info -E header=y -Y "$prot $ipFilter" >> $output_file
    }
}

# Dispose of the form when done
$form.Dispose()

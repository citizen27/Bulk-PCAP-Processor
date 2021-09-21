function PCAP($folder) {

Write-Host($folder)
$files = ".pcap"
$output_file = "Path to outoput file"

#Make sure your path for Wireshark and tshark matches this

$tshark = "C:\Program Files\Wireshark\tshark"

# User Interface showing the user the output location of the files

echo "-- Analyzing Your Files --"
echo "Your results will be saved in a CSV Form here  --> $output_file"

#User input required for this section

$prot=Read-Host "What protocol do you want to filter for (leave blank to search all protocols)"
$ip=Read-Host "What IP Address do you want to filter for (leave blank to search for all IPs)"
if($ip -ne ""){
    $ip = "ip.addr==" + $ip
    if($prot -ne ""){
        $ip = " && " + $ip
    }
}

# For loop to go through each object, and run the tshark program and options against
# that file.

# tshark options can be customized, but MOST prevalent options are preloaded.

# The $i=0 allows for cleaner formatting in the .csv file in Notepad
# as it creates a blank line, then tells you the next file you are analyzing
# then another blank line for easier interpretation of the results.

$i = 0

Get-ChildItem $folder | foreach-Object{
if ($i -ne 0) {
  Add-Content -Path $output_file -Value "`n$($_.FullName)`n"
}
$i++
	echo $f 
	& $tshark -r $_.FullName -T fields -e frame.number -e frame.time -e _ws.col.Protocol `
	-e ip.src -e ip.dst -e _ws.col.Length -e _ws.col.Info -E header=y -Y "$prot $ip" >> $output_file
}}


#
# documents helper function, this generates submenus on-the-fly.
#
function Add-SubMenuItems {
    
    # Only make each submenu once.
    # If you move the mouse away and back we don't want to recreate it.
    if ($this.DropDownItems.Count -eq 1 -and $this.DropDownItems[0].Text -eq '')
    {
        $this.DropDownItems.Clear()    # Remove placeholder
        
        # Add new menu items for each file or directory.
        #  - directories fill in their contents into their submenu when hovered over.
        #  - files print their name when clicked.
        [array]$items = Get-ChildItem -LiteralPath $this.Tag -ErrorAction SilentlyContinue | 
                            Sort-Object -Property PSIsContainer, Name

        if ($items.Count -gt 0)
        {
            $items | ForEach-Object {

                $tempItem = New-Object System.Windows.Forms.ToolStripMenuItem -ArgumentList $_.Name
                $tempItem.Tag = $_.FullName
                
                if ($_.PsIsContainer)  # Directory - add a blank submenu item, so it has the > hint
                {
                    $tempItem.Add_MouseHover({ Add-SubMenuItems })
                    $tempSubSubMenu = New-Object System.Windows.Forms.ToolStripMenuItem  
                    [void]$tempItem.DropdownItems.Add($tempSubSubMenu)
                }
                else  # it's a file, add a Click handler
                {
                   $tempItem.Add_Click({ 
                       PCAP($this.Tag)
                    })
                }
                
                # add each new item to the menu
                [void]$this.DropDownItems.Add($tempItem)
            }
        }
        else
        {
            $this.Text = $this.Text + '  (empty)'
        }
    }
}


function OnFormClosing_MenuForm($Sender,$e){ 
    # $this represent sender (object)
    # $_ represent  e (eventarg)

    # Allow closing
    ($_).Cancel= $False
}

function Menu {
# These are the starting folders
$documentRoots = 'C:\Users\'
$Example

# Load Windows forms assemblies
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")


#
# documentsToolStripMenuItem - this is the bit which says "Documents" along the top
#
$documentsToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
$documentsToolStripMenuItem.Name = "documentsToolStripMenuItem"
$documentsToolStripMenuItem.Text = "&Documents"

# For each document root,
# Create a menu entry to go under "Documents".
# Give it an empty sub menu, so it has the > arrow.
# Register an event handler so it responds to mouse hover.
# Add it to the document parent menu.
#
# This can't use the helper function because it
# adds to the Documents top-level menu.
foreach ($root in $documentRoots)
{
    $tempItem = New-Object System.Windows.Forms.ToolStripMenuItem -ArgumentList ($root)
    $tempItem.Add_MouseHover({ Add-SubMenuItems })
    $tempItem.Tag = $root
    $tempSubMenu = New-Object System.Windows.Forms.ToolStripMenuItem
    [void]$tempItem.DropDownItems.Add($tempSubMenu)
    
    [void]$documentsToolStripMenuItem.DropDownItems.Add($tempItem)
}

#
# Main menu bar
#
$MenuStrip = new-object System.Windows.Forms.MenuStrip
[void]$MenuStrip.Items.Add($documentsToolStripMenuItem)
$MenuStrip.Location = new-object System.Drawing.Point(0, 0)
$MenuStrip.Name = "MenuStrip"
$MenuStrip.Size = new-object System.Drawing.Size(354, 24)
$MenuStrip.TabIndex = 0
$MenuStrip.Text = "menuStrip1"

#
# Main Form
#
$MenuForm = new-object System.Windows.Forms.form
$MenuForm.ClientSize = new-object System.Drawing.Size(354, 141)
[void]$MenuForm.Controls.Add($MenuStrip)
$MenuForm.MainMenuStrip = $MenuStrip
$MenuForm.Name = "MenuForm"
$MenuForm.Text = "PCAParser"

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$MenuForm.AcceptButton = $okButton
$MenuForm.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$MenuForm.CancelButton = $cancelButton
$MenuForm.Controls.Add($cancelButton)


$MenuForm.Add_FormClosing( { OnFormClosing_MenuForm $MenuForm $EventArgs} )
$MenuForm.Add_Shown({$MenuForm.Activate()})
$MenuForm.ShowDialog()
#Free ressources
$MenuForm.Dispose()
}
Menu
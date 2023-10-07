Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

$folder = "USER INPUT"

$output_file = "User input (IN .CSV FORMAT)"

# Make the tshakr variable your install location for Wireshark\tshark"
$tshark = "C:\Program Files\Wireshark\tshark"

# User Interface showing the user the output location of the files
Write-Host "-- Analyzing Your Files --"
Write-Host "Your results will be saved in a CSV File here --> $output_file"

# User input required for this section
$prot = Read-Host "What protocol do you want to filter for (leave blank to search all protocols)"
$ip = Read-Host "What IP Address do you want to filter for (leave blank to search for all IPs)"

$ipFilter = ""
if ($ip -ne "") {
    $ipFilter = "ip.addr==" + $ip
    if ($prot -ne "") {
        $ipFilter = " && " + $ipFilter
    }
}

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

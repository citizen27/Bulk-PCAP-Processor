# Bulk_PCAP_Processor 📊

Welcome to the **Bulk_PCAP_Processor *, your solution for efficient packet capture file analysis using PowerShell and a user-friendly Windows Forms interface.

## Prerequisites 🛠️

Ensure the following prerequisites are in place:

- **Wireshark**: Wireshark, including the `tshark` command-line utility, must be installed. Specify the correct `tshark` path in the script.

- **PowerShell**: Ensure PowerShell is available on your Windows system.

## 🚀 Usage 🚀

**You can run the standalone that is compiled from "Code". This is found in "Application".**

1. **Run the Script**: Execute the `Bulk_PCAP_Processor.ps1` script with a double-click. Ensure script execution permissions are granted.

2. **GUI**: The Windows Forms GUI provides essential options:

   - **Select Input Folder**: Use the "Browse" button to choose the folder containing your packet capture files.

   - **Specify Output CSV**: Set the path and name of the CSV file where results will be stored.

   - **Filter by Protocol**: Optionally, enter an network protocol to narrow results.

   - **Filter by IP Address**: Optionally, enter an IP address to narrow results.

3. **Analysis**: Click "OK" to start analysis. The script:

   - Analyzes log files in the chosen folder with Wireshark (`tshark`) based on protocol and IP filters.

   - Appends results to the output CSV, including frame number, timestamp, protocol, source/destination IP addresses, packet length, and details.

   - Displays progress in the PowerShell console and a summary.

4. **Completion**: Once analysis finishes, results are saved in the CSV file, and the GUI closes.

## ⚠️ Troubleshooting ⚠️

- Verify Wireshark installation and `tshark` path in the script.

- Ensure necessary permissions for input and output folders. Admin rights can resolve most issues.

## License 📜

This script is under the [MIT License](LICENSE). 

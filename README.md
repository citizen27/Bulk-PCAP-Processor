# Bulk_PCAP_Processor with PowerShell GUI

This script allows you to analyze Wireshark log files (.pcap) using PowerShell and provides a user-friendly Windows Forms GUI for selecting input paths, specifying filtering criteria, and choosing an output CSV file.

## Prerequisites

- **Wireshark**: You need to have Wireshark installed on your system, including the `tshark` command-line utility. Make sure to provide the correct path to `tshark` in the script.

- **PowerShell**: This script requires PowerShell to run. PowerShell is usually pre-installed on Windows systems.

## Usage

1. **Run the Script**: Double-click the script file (`Bulk-PCAP-Processor.ps1`) to execute it. Ensure that script execution is allowed on your system.

3. **GUI**: The script will display a Windows Forms GUI for interacting with the tool.

   - **Select a folder containing log files**: Click the "Browse" button next to this field to choose the folder where your Wireshark log files are located.

   - **Select an output CSV file**: Click the "Browse" button next to this field to specify the path and name of the CSV file where the results will be saved.

   - **Select a protocol (leave blank to search all protocols)**: Choose a specific network protocol to filter the log files. You can leave this field blank to analyze all protocols.

   - **Enter an IP Address (leave blank to search for all IPs)**: Optionally, enter an IP address to further filter the results. Leave this field blank to analyze all IP addresses.

4. **Analysis**: Click the "OK" button to start the analysis. The script will:

   - Analyze the log files in the selected folder using Wireshark (`tshark`) based on the specified protocol and IP filter.

   - Create or append to the output CSV file with the analysis results, including frame number, frame time, protocol, source and destination IP addresses, packet length, and packet info.

   - Display progress in the PowerShell console and provide a summary of the analysis location.

   - You can monitor the script's progress and see the results saved in the specified CSV file.

5. **Completion**: Once the analysis is complete, you will see the results saved in the specified CSV file. The GUI will close automatically.

## Troubleshooting

- If you encounter any errors or issues, ensure that Wireshark is correctly installed, and the `tshark` executable's path is set correctly in the script.

- Make sure that you have the necessary permissions to read the input folder and write to the output CSV file.

## License

This script is provided under the [MIT License](LICENSE).

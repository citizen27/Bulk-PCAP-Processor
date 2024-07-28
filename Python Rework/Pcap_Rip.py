import os
import subprocess
import csv
from pathlib import Path

def run_tshark(pcap_file, filters, tshark_path):
    tshark_cmd = [
        tshark_path,
        "-r", str(pcap_file),
        "-T", "fields",
        "-e", "frame.number",
        "-e", "frame.time",
        "-e", "_ws.col.Protocol",
        "-e", "ip.src",
        "-e", "ip.dst",
        "-e", "_ws.col.Length",
        "-e", "_ws.col.Info",
        "-E", "header=y"
    ]

    if filters:
        tshark_cmd.extend(["-Y", filters])

    result = subprocess.run(tshark_cmd, capture_output=True, text=True)
    return result.stdout

def main():
    # User Inputs
    folder = input("Enter the folder containing PCAP files: ")
    output_file = input("Enter the output CSV file name (with .csv extension): ")

    # Ask user to select default tshark path or provide custom path
    default_tshark_path = "C:\\Program Files\\Wireshark\\tshark.exe"
    use_default_path = input(f"Do you want to use the default path for tshark ({default_tshark_path})? (yes/no): ").strip().lower()
    if use_default_path == 'yes':
        tshark_path = default_tshark_path
    else:
        tshark_path = input("Enter the full path to the tshark executable: ")

    # Validate tshark path
    if not os.path.isfile(tshark_path):
        print(f"The specified tshark path does not exist: {tshark_path}")
        return

    # Validate the folder
    if not os.path.isdir(folder):
        print(f"The folder {folder} does not exist.")
        return

    # User Inputs for filters
    protocol_filter = input("Enter the protocol to filter (leave blank to search all protocols): ")
    ip_filter = input("Enter the IP Address to filter (leave blank to search all IPs): ")
    port_filter = input("Enter the Port number to filter (leave blank to search all Ports): ")

    filters = []
    if protocol_filter:
        filters.append(f"{protocol_filter}")
    if ip_filter:
        filters.append(f"ip.addr=={ip_filter}")
    if port_filter:
        filters.append(f"(tcp.port=={port_filter} || udp.port=={port_filter})")

    filter_string = " && ".join(filters)

    # Initialize CSV file
    with open(output_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Frame Number', 'Frame Time', 'Protocol', 'Source IP', 'Destination IP', 'Length', 'Info'])

        # Iterate over each file in the directory
        for pcap_file in Path(folder).rglob('*.pcap'):
            if not pcap_file.is_file():
                print(f"Skipping {pcap_file}, as it is not a valid file.")
                continue

            print(f"Analyzing {pcap_file}...")
            try:
                tshark_output = run_tshark(pcap_file, filter_string, tshark_path)
                # Skip the header line and write the rest to the CSV
                for line in tshark_output.splitlines()[1:]:
                    writer.writerow(line.split('\t'))
            except Exception as e:
                print(f"Error analyzing {pcap_file}: {e}")

    print(f"Analysis complete. Results saved in {output_file}.")

if __name__ == "__main__":
    main()

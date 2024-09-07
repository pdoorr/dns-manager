# DNS Manager

DNS Manager is a simple, user-friendly GUI application for managing DNS settings on Linux systems. It allows users to easily switch between different DNS servers, add custom DNS servers, and manage their DNS configurations.

## Features

- Switch between predefined DNS servers
- Add, edit, and delete custom DNS servers
- Multilingual support (English and Italian)
- Simple and intuitive graphical interface

## Requirements

- Bash
- Zenity
- NetworkManager

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/dns-manager.git
   ```

2. Navigate to the project directory:
   ```
   cd dns-manager
   ```

3. Make the script executable:
   ```
   chmod +x dns-manager
   ```

4. Run the script:
   ```
   sudo ./dns-manager
   ```

## Usage

After launching the application, you can:

- Change DNS: Select a predefined or custom DNS server to use.
- Add DNS Server: Add a new custom DNS server.
- Edit DNS Server: Modify an existing custom DNS server.
- Delete DNS Server: Remove a custom DNS server from the list.

## Building a Debian Package

To create a Debian package for easy distribution and installation:

1. Ensure you have the `dpkg-deb` tool installed.

2. Run the packaging script:
   ```
   ./create-package.sh
   ```

3. Install the created package:
   ```
   sudo dpkg -i dns-manager_1.0-1.deb
   sudo apt-get install -f
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)

## Acknowledgments

- Thanks to all contributors and users of DNS Manager.
- Icon created using SVG.
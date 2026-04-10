# tar1090 Installer Documentation

The `install.sh` script is the primary installer and updater for tar1090. It handles dependency management, configuration generation, and service setup for both Lighttpd and Nginx environments.

## Core Functions

### 1. **Initial Setup & Hygiene**
- **Root Checks**: Ensures the script is run with appropriate permissions.
- **Directories**: Establishes installation directories (default: `/usr/local/share/tar1090`).
- **User Creation**: Creates a system user `tar1090` if it doesn't exist, for running the service securely.

### 2. **Dependency Management**
- Checks for and installs required packages via `apt-get`:
    - `git`
    - `jq`
    - `curl`

### 3. **Repository & Database Handling**
- **Git Cloning**: Clones or updates the main `tar1090` repository and the `tar1090-db` (database) repository.
- **Database Optimization**: Checks if the git database is too large (>150MB) and cleans it up if necessary.
- **Version Tracking**: Fetches and verifies version numbers from the remote repository to ensure up-to-date files.

### 4. **Service Configuration**
- **Auto-Detection**: file `aircraft.json` is auto-detected in common locations (`/run/readsb`, `/run/dump1090-fa`, etc.) to determine the data source.
- **Multi-Instance Support**: Can configure multiple instances (e.g., for different receivers) based on arguments or `/etc/default/tar1090_instances`.

### 5. **Web Server Configuration**
The script handles both **Lighttpd** and **Nginx** configuration.

#### Lighttpd
- **Config Generation**: Generates and enables configuration files in `/etc/lighttpd/conf-available`.
- **Automatic Enable**: Uses `lighty-enable-mod` or directs symlinking to activate the configuration.
- **Restart**: Restarts the `lighttpd` service automatically.

#### Nginx
- **Config Generation**: Generates `nginx-${service}.conf` for inclusion in your main nginx server block.
- **Restart**: Automatically restarts the `nginx` service to apply changes if it is installed and running.
- **Instructions**: Prints instructions on how to include the generated configuration file in your nginx config.


### 6. **Deployment & Restart**
- **File Copying**: Copies HTML, CSS, and JS files to the installation directory.
- **Cache Busting**: Runs `cachebust.sh` to ensure browsers load the latest versions of static files.
- **Service Restart**: Restarts the `tar1090` systemd service.

## Usage Options
The script accepts optional command-line arguments:
1.  **Data Source Directory** (e.g., `/run/readsb`)
2.  **Web Path** (default: `tar1090`, use `webroot` for `/`)
3.  **Install Path** (optional override)
4.  **Git Source** (optional local git path)

## Output
Upon completion, the script prints the URL where the web interface is accessible (e.g., `http://<IP>/tar1090`).

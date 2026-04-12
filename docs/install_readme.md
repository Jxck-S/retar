# tar1090 Installer Documentation

The `install.sh` script is the primary installer and updater for tar1090 (retar). It handles dependency management, configuration generation, and service setup for both Lighttpd and Nginx environments. It does **not** install the aircraft/map **HTML database** (`db-*`); that is a separate concern from the UI package.

## Core Functions

### 1. **Initial Setup & Hygiene**
- **Root Checks**: Ensures the script is run with appropriate permissions.
- **Directories**: Establishes installation directories (default: `/usr/local/share/tar1090`).
- **User Creation**: Creates a system user `tar1090` if it doesn't exist, for running the service securely.

### 2. **Dependency Management**
- Checks for and installs required packages via `apt-get`:
    - `git`
    - `jq` (used when writing **`version.json`**, and when applying **`PAGENAME`** / **`DESCRIPTION`** to **`manifest.webmanifest`**)
    - `curl`

### 3. **Repository handling**
- **Git cloning**: Clones or updates the main **retar** / tar1090 web repository into the update directory (default: under the install path), unless you use **`test`** (local tree) or a **local git path** as the fourth argument.
- **Version check**: Compares the remote `version` file to the cached checkout and refreshes when the upstream version changes (or when you pass **`force`**).
- **Aircraft / map database**: The installer **does not** download **tar1090-db** or copy a `db-*` directory into the HTML tree. The sharded JS database and readsb `aircraft.csv` are expected to come from a **separate** step (for example the **retar-db** build pipeline or any tar1090-compatible `db` bundle you maintain yourself).

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
- **File copying**: Stages a fresh copy of the HTML, CSS, and JS assets, then preserves instance-specific files already on disk (for example `config.js`, `banner.html`, `banner.css`) from the previous `html` directory where applicable.
- **`version.json`**: Each instance’s staged tree gets a new **`version.json`** with **`tar1090Version`** (from the checked-out repo) and **`databaseVersion`**. If **`version.json`** already exists next to that instance’s current `index.html` and **`databaseVersion`** is a non-empty string or number, that value is **reused** and **`index.html`**’s **`databaseFolder`** is set to **`db-<databaseVersion>`** so an existing database directory keeps working. If nothing is known yet, **`databaseVersion`** is written as an empty string so another script or process can fill it in later.
- **Cache busting**: Runs `cachebust.sh` so browsers pick up updated static files.
- **Service restart**: Restarts the `tar1090` systemd unit(s) for the configured instance(s).

## Usage Options
The script accepts optional command-line arguments:
1.  **Data Source Directory** (e.g., `/run/readsb`)
2.  **Web Path** (default: `tar1090`, use `webroot` for `/`)
3.  **Install Path** (optional override)
4.  **Git Source** (optional local git path)

## Output
Upon completion, the script prints the URL where the web interface is accessible (e.g., `http://<IP>/tar1090`).

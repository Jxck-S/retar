# Development & Testing Guide

This guide covers how to test changes locally before committing or deploying them.

---

## Testing Changes Locally
If you are making modifications to the HTML, CSS, or JavaScript and want to see how they look in a real environment:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Jxck-S/retar.git
    cd retar
    ```
2.  **Make your changes:** Edit the files in the `html/` directory.
3.  **Deploy for testing:** Run the install script with the `test` flag. This will install the package from your local directory instead of downloading from GitHub:
    ```bash
    sudo ./install.sh test
    ```

---

## Technical Architecture
For details on how the frontend interacts with the decoder and web server, please refer to the **[Technical Guide](docs/TECHNICAL.md)**.

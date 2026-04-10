# Web Server Configuration

This document contains instructions for configuring various web servers and hosting providers to work with retar/tar1090.

## lighttpd

tar1090 is now available at :8504 by default when using lighttpd. (port 8504)

To display tar1090 at /, add an instance as described above that has the name webroot.
It will be available at /

## nginx configuration

If nginx is installed, the install script should give you a configuration file
you can include.  The configuration needs to go into the appropriate server { }
section.
In the usual configuration that means to add this line:
```
include /usr/local/share/tar1090/nginx-tar1090.conf;
```
in the server { } section of either `/etc/nginx/sites-enabled/default` or `/etc/nginx/conf.d/default.conf` depending on your system configuration.
Don't forget to restart the nginx service.

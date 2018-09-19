Squiddo-server
==============

Domains whitelisting with SquidGuard, maintained via an android app.

Installation instructions and such will be written once it's a bit further
through.

Concept
=======

Donna wishes to control Sally's internet access - so sets up a laptop for
Sally running any linux distribution of her choice. She creates a user for 
Sally which does not have root access, and installs squidgard and this
application on it, providing the necessary environment variables to get it
running.

She then blocks off all external connections from processes running under
Sally's uid, but allows connections to localhost, and DNS. She configures
Sally's user account and internet browsers to use the squidguard as a proxy.

Donna then sets up her android phone with the Squiddo app and provides it the
URI of the application running on Sally's laptop.

Any time Sally attempts to access a website not in the domains whitelist, she
has the option to click a link which logs the request uri she tried to access.
The application sends a push notification to Donna's phone, and when she opens
the Squiddo app she's shown a list of all the requests Sally has made that she
hasn't dealt with yet.

Donna then has the option to preview the page Sally was trying to access before
deciding whether to allow or deny access to that domain.

Meanwhile, the page Sally was on has been refreshing every few seconds, and
once Donna's mind has been made up it either redirects her to the page or tells
here that her access request has been declined.

Considerations
==============

In order to make it hard-to-impossible for Sally to circumvent the restriction,
the following considerations need to be made:

* she must not have root on the system running the application
* she must not have physical access to the motherboard of the system
* she must not have access to Donna's password for administration
* she must not have filesystem access to the code / configuration files of the
  application, nor of its init system configuration
* she must not be able to alter firewall rules, and there must be one in place
  preventing any of her processes from connecting to the internet directly.

You could create a firewall rule to force all HTTP requests to go through
squidguard, but it is not necessary if Sally is simply unable to make any
direct connections any other way.

The application and squidguard must be running on the same machine, but it does
not have to be Sally's computer - it simply changes the firewall rule that must
be made. In that case, the firewall rule should allow connections to the system
running the application (on the correct port), rather than to localhost.

Set up
======

These instructions assume you have one user account you want to filter the internet usage of. If you have more than one you can either repeat the final firewall rule for each user (replacing `unprivileged` with their usernames, or put each user into an unprivileged internet access group and use iptables' `gid` module like `iptables -A OUTPUT -m gid --gid-owner group-here -j DENY`

* Set up a linux machine with your chosen distro (this guide is going to assume Debian stretch) and some kind of GUI
  * Configure the BIOS / firmware to boot straight from the built-in disks without trying removable media (CD, USB, etc.)
* Install docker (optional)
* Create an account which will be locked down (they're called `unprivileged` for the rest of this guide - replace `unprivileged` in any instructions with the username you have chosen.
  * Ensure they do not have access to
    * sudo
    * docker daemon (if installed)
    * the root account
    * the motherboard / motherboard firmware

* Set up your firewall:
  ```sh
  iptables -A OUTPUT -m tcp --dport 53 -j ALLOW # allow DNS access unconditionally
  iptables -A OUTPUT -m udp --dport 53 -j ALLOW # allow DNS access unconditionally
  iptables -A OUTPUT -m tcp --dest 127.0.0.1/8 -j ALLOW # always allow access to localhost
  iptables -A OUTPUT -m uid --uid-owner unprivileged -j DENY # deny unprivileged's direct access to the internet
  ```
  * Set up your firewall config to persist somehow. Under debian, `iptables-persistent is a relatively easy way to do this.

* Install squiddo-server, either...
  * With docker:
    *  ```
       git clone http://gitlab.com/horntelin/squiddo-server.git
       cd squiddo-server
       docker-compose up --restart always
       ```
  * Or as a debian package
    * ```
      wget url/to/squiddo-server.deb
      dpkg -i squiddo-server.deb
      apt install -f
      ```
* Set up unprivileged's proxy config to be 127.0.0.1:8080 for all protocols

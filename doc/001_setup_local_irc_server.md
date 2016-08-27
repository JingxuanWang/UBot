## Setup local IRC server for Mac OS X

From http://apple.stackexchange.com/questions/19411/how-do-i-set-up-an-irc-server-on-os-x-for-my-local-network

    brew install ngircd

    # Add /usr/local/sbin to your PATH
    vi ~/.bash_profile

    # edit ngircd config file
    cd /usr/local/mxcl-homebrew-697d2ae/Cellar/ngircd/17.1/etc/
    vi ngircd.conf

    # verify config
    ngircd --configtest

    # start
    ngircd


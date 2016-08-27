init:
	cd script && ./install_deps
test:
	cd t && prove -I ../lib -r .
coverage:
	cd t && ./coverage_test
client-irc-dev:
	cd script && ./ubot-client ../conf/development/client-irc.conf
server-dev:
	cd script && ./ubot-server daemon -m development

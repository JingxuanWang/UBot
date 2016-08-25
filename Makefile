init:
	cd script && ./install_deps
test:
	prove -I lib -r t
coverage:
	cd t && ./coverage_test
server-dev:
	cd script && ./ubot-server daemon -m development

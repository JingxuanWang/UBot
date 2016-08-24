init:
	cd script && ./install_deps
test:
	prove -I lib -r t
coverage:
	cd t && ./coverage_test
dev:
	cd script && perl app.pl

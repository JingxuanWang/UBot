init:
	cd script && ./install_deps
test:
	cd t && ./coverage_test
dev:
	cd script && perl app.pl

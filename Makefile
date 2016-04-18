COFFEE=node_modules/.bin/coffee -c -o dist

all: dist
	$(COFFEE) src

watch: dist
	$(COFFEE) -w src

dist:
	mkdir -p $@


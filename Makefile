dev: src/*.elm
	elm make --output=docs/js/index.js --debug src/Main.elm

prod: src/*.elm
	elm make --output=docs/js/index.js --optimize src/Main.elm

serve:
	python3 -m http.server --dir public

.PHONY: dev prod serve

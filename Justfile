prettier := "prettier --write --loglevel silent"

# Update
update: build-readme
	{{prettier}} meta/*.yaml
	git add . && pre-commit

# Build the README
build-readme:
	cat bib/* > bibliography.bib
	cd docs && pandoc -d readme.yaml
	{{prettier}} README.md

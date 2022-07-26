# Update
update: build-readme
	git add . && pre-commit

# Build the README
build-readme:
	cat bib/* > bibliography.bib
	cd docs && pandoc -d readme.yaml

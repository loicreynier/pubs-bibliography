prettier := "prettier --write --loglevel silent"

# Update
update: build-readme
	@git add .
	@pre-commit

# Build the README
build-readme: format
	@sh docs/make-bib.sh
	@sh docs/make-readme.sh

# Format meta files
format:
	@{{prettier}} meta/*.yaml

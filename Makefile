.DEFAULT_GOAL := bootstrap

install_tools:
	brew bundle --no-lock --no-upgrade || true
	bundle install

bootstrap: install_tools
	bundle exec fastlane bootstrap

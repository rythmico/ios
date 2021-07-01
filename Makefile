.DEFAULT_GOAL := bootstrap

install_tools:
	brew bundle --no-lock --no-upgrade || true

bootstrap: install_tools
	fastlane bootstrap

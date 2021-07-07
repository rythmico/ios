.DEFAULT_GOAL := bootstrap

bootstrap:
	brew bundle --no-lock --no-upgrade || true
	fastlane bootstrap

ci:
	fastlane ci

deploy:
	fastlane deploy

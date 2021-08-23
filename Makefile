.DEFAULT_GOAL := bootstrap

bootstrap:
	brew bundle --no-lock --no-upgrade || true
	bundle install
	bundle exec fastlane bootstrap

ci:
	bundle exec fastlane ci

deploy:
	bundle exec fastlane deploy

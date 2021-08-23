.DEFAULT_GOAL := bootstrap

bootstrap:
	bundle exec fastlane bootstrap

ci:
	bundle exec fastlane ci

deploy:
	bundle exec fastlane deploy

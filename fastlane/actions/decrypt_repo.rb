module Fastlane
  module Actions
    class DecryptRepoAction < Action
      def self.run(params)
        if ENV['CI']
          unless ENV['GIT_CRYPT_KEY']
            UI.user_error! 'GIT_CRYPT_KEY env var not found in this CI environment'
          end
          sh 'echo $GIT_CRYPT_KEY | base64 -D > /tmp/git-crypt.key'
          sh 'git-crypt unlock /tmp/git-crypt.key'
        else
          sh 'git-crypt unlock'
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Runs 'git-crypt unlock' on the repo to decrypt its secrets"
      end

      def self.authors
        ["davdroman"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

module Fastlane
  module Actions
    class LastGitCommitAuthorAction < Action
      def self.run(params)
        commit = Fastlane::Actions::LastGitCommitAction.run(nil)
        name = commit[:author]
        email = commit[:author_email]
        return name + " <" + email + ">"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Returns last Git commit author"
      end

      def self.details
        "Format: Name <Email>"
      end

      def self.is_supported?(platform)
        true
      end

      def self.category
        :source_control
      end

      def self.sample_return_value
        "davdroman <d@vidroman.dev>"
      end

      def self.authors
        ["davdroman"]
      end
    end
  end
end

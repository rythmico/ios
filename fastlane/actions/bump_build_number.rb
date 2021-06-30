module Fastlane
  module Actions
    class BumpBuildNumberAction < Action
      def self.run(params)
        plist_path = params[:plist]

        # Determine new build number
        param_build = params[:value]
        plist_build = -> {
          Fastlane::Actions::GetInfoPlistValueAction.run(
            path: plist_path,
            key: 'CFBundleVersion'
          ).to_i + 1
        }
        bump = (param_build || plist_build.call).to_s

        # Set new build number
        Fastlane::Actions::SetInfoPlistValueAction.run(
          path: plist_path,
          key: 'CFBundleVersion',
          value: bump
        )
        Actions.lane_context[:BUILD_NUMBER] = bump
        return bump
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Increments the CFBundleVersion for a specific Info.plist file'
      end

      def self.details
        <<~EOS
        The priority in which the new build number is chosen is:
          1. The `value` parameter of the action
          2. The current CFBundleVersion value incremented by 1
        EOS
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :plist,
            env_name: nil,
            description: "Path to the Info.plist file",
            is_string: true,
            default_value: nil,
          ),
          FastlaneCore::ConfigItem.new(
            key: :value,
            env_name: nil,
            description: "New build number to use",
            optional: true,
            is_string: false,
            default_value: nil,
          )
        ]
      end

      def self.output
        [
          ['BUILD_NUMBER', 'The new build number']
        ]
      end

      def self.return_value
        'The new build number'
      end

      def self.authors
        ['davdroman']
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

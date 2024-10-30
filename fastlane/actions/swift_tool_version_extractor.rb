module Fastlane
  module Actions
    class SwiftToolVersionExtractorAction < Action
      module SharedValues
        SWIFT_TOOL_VERSION = :SWIFT_TOOL_VERSION
      end

      # Run The Action With Parameters
      def self.run(params)
        tool = params[:tool]
        unless ['lint', 'format'].include?(tool)
          # Invalid Tool Specified
          UI.user_error!("💩 Invalid Tool Specified. Please Specify 'Lint' For SwiftLint Or 'Format' For SwiftFormat ❌")
        end

        # Display Tool Version And Executable Path
        UI.message("🔍 Swift#{tool.capitalize} Version: #{self.swiftToolVersionFromFile(tool)}")
        UI.message("🔍 Swift#{tool.capitalize} Executable: #{self.swiftToolExecutable(tool)}")
        
        if self.swiftToolExecutable(tool).empty?
          # Tool Is Not Installed
          UI.user_error!("💩 Swift#{tool.capitalize} Is Not Installed. ⚙️ Please Run Fastlane SetupBaseDependencies ❌")
        end
        
        swifttool_version = swiftToolVersionFromFile(tool)
        swifttool_executable = swiftToolExecutable(tool)

        # Return Version And Executable
        return {
          swifttool_version: swifttool_version,
          swifttool_executable: swifttool_executable
        }
      end

      #  Get Tool Executable Path
      def self.swiftToolExecutable(tool)
        # Add Directory Containing Swift Tool To The PATH
        ENV['PATH'] = "#{ENV['PATH']}:#{Dir.home}/.mint/bin"
        # Return The Full Path To The Swift Tool Executable
        tool_name = tool == 'lint' ? 'swiftlint' : 'swiftformat'
        return "#{Dir.home}/.mint/bin/#{tool_name}"
      end

      # Extract Tool Version From Mintfile
      def self.swiftToolVersionFromFile(tool)
        mintfile_path = File.expand_path('fastlane/Mintfile')
        if File.exist?(mintfile_path)
          mintfile_content = File.read(mintfile_path)
          tool_regex = tool == 'lint' ? /realm\/SwiftLint@(\d+\.\d+\.\d+)/ : /nicklockwood\/SwiftFormat@(\d+\.\d+\.\d+)/
          tool_line = mintfile_content.match(tool_regex)
          tool_version = tool_line[1] if tool_line
          if tool_version
            # Return Version
            return Gem::Version.new(tool_version)
          end
        end
        # Version Not Found In Mintfile
        UI.user_error!("💩 Swift#{tool.capitalize} Version Not Found In Mintfile ❌")
      end

      # Action Description
      def self.description
        "📘 Extrapolate Swift Tool Version From Mintfile"
      end

      # Define Available Options
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :tool,
                                       env_name: "FL_SWIFT_TOOL_VERSION_TOOL",
                                       description: "The Tool To Use ('Lint' For SwiftLint, 'Format' For SwiftFormat)",
                                       is_string: true,
                                       default_value: 'lint')
        ]
      end

      # Authors
      def self.authors
        ["Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ"]
      end

      # Supported Platforms
      def self.is_supported?(platform)
        true
      end
    end
  end
end

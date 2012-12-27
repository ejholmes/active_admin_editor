require 'logger'

module ActiveAdmin
  module Editor
    class << self
      # Returns the current Configuration
      def configuration
        @configuration ||= Configuration.new
      end

      # Yields the Configuration
      def configure
        yield configuration
      end
    end

    class Configuration
      attr_accessor :aws_access_key_id
      attr_accessor :aws_access_secret
    end
  end
end

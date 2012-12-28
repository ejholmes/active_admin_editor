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
      attr_accessor :s3_bucket
      attr_accessor :storage_dir

      def storage_dir
        @storage_dir ||= 'uploads'
      end

      def storage_dir=(dir)
        @storage_dir = dir.to_s.gsub(/(^\/|\/$)/, '')
      end

      def s3_configured?
        aws_access_key_id.present? &&
          aws_access_secret.present? &&
          s3_bucket.present?
      end
    end
  end
end

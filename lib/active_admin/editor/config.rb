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
      # AWS credentials
      attr_accessor :aws_access_key_id
      attr_accessor :aws_access_secret

      # The s3 bucket to store uploads.
      attr_accessor :s3_bucket

      # wysiwyg stylesheets that get included in the backend and the frontend.
      attr_writer :stylesheets
      
      # wysihtml5 cleanUp options
      attr_writer :clean_up

      def storage_dir
        @storage_dir ||= 'uploads'
      end

      def storage_dir=(dir)
        @storage_dir = dir.to_s.gsub(/(^\/|\/$)/, '')
      end

      def stylesheets
        @stylesheets ||= [ 'active_admin/editor/wysiwyg.css' ]
      end
      
      def clean_up
        @clean_up.nil? ? true : !!@clean_up
      end

      def s3_configured?
        aws_access_key_id.present? &&
          aws_access_secret.present? &&
          s3_bucket.present?
      end

      def parser_rules
        @parser_rules ||= PARSER_RULES.dup
      end
    end
  end
end

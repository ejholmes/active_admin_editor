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

      # Base directory to store the uploaded files in the bucket. Defaults to
      # 'uploads'.
      attr_accessor :storage_dir

      # wysiwyg stylesheets that get included in the backend and the frontend.
      attr_accessor :stylesheets

      # paths to client side templates in the asset pipeline
      attr_accessor :template_paths

      def storage_dir
        @storage_dir ||= 'uploads'
      end

      def storage_dir=(dir)
        @storage_dir = dir.to_s.gsub(/(^\/|\/$)/, '')
      end

      def stylesheets
        @stylesheets ||= [ 'active_admin/editor/wymiwyg.css' ]
      end

      def s3_configured?
        aws_access_key_id.present? &&
          aws_access_secret.present? &&
          s3_bucket.present?
      end

      def parser_rules
        @parser_rules ||= PARSER_RULES.dup
      end

      def template_paths
        defaults = {
          toolbar: 'active_admin/editor/templates/toolbar',
          uploader: 'active_admin/editor/templates/uploader'
        }
        @template_paths ? @template_paths.reverse_merge!(defaults) : defaults
      end
    end
  end
end

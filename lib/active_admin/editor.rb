require 'base64'
require 'openssl'
require 'digest/sha1'
require 'json'

require 'active_admin/editor/version'
require 'active_admin/editor/config'
require 'active_admin/editor/rails/engine'

module ActiveAdmin
  module Editor
    class << self

      def policy_document
        { :expiration => Time.now.utc + 1.hour,
          :conditions => [
            { :bucket => config.s3_bucket },
            [ 'starts-with', '$key', '' ],
            { :acl => 'public-read' },
            [ 'starts-with', '$Content-Type', '' ],
            [ 'content-length-range', 0, 524288000 ]
          ]
        }
      end

      def encoded_policy_document
        Base64.encode64(policy_document.to_json).gsub("\n", '')
      end

      def signature
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            config.aws_access_secret,
            encoded_policy_document
          )
        ).gsub("\n", '')
      end

    private

      def config
        ActiveAdmin::Editor.configuration
      end

    end
  end
end

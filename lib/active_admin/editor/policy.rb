require 'base64'
require 'openssl'
require 'digest/sha1'
require 'json'

module ActiveAdmin
  module Editor
    class Policy

      def document
        @document ||= Base64.encode64(document_hash.to_json).gsub("\n", '')
      end

      def signature
        @signature ||= Base64.encode64(digest).gsub("\n", '')
      end

    private

      def document_hash
        { :expiration => Time.now.utc + 1.hour,
          :conditions => [
            { :bucket => configuration.s3_bucket },
            [ 'starts-with', '$key', '' ],
            { :acl => 'public-read' },
            [ 'starts-with', '$Content-Type', '' ],
            [ 'content-length-range', 0, 524288000 ]
          ]
        }
      end

      def digest
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha1'),
          configuration.aws_access_secret,
          document
        )
      end

      def configuration
        ActiveAdmin::Editor.configuration
      end

    end
  end
end

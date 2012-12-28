require 'base64'
require 'openssl'
require 'digest/sha1'
require 'json'

module ActiveAdmin
  module Editor
    # Public: Class used to generate a new S3 policy document, which can be
    # used to authorize a direct upload to an S3 bucket.
    #
    # Examples
    #
    #   policy = Policy.new
    #   # => #<ActiveAdmin::Editor::Policy:0x007fa9ec41f440>
    #
    #   policy.document
    #   # => "eyJleHBpcmF0aW9uIjo...gwMDBdXX0="
    #
    #   policy.signature
    #   # => "NakHRb4SaI8cpU5RtSVh25kj/sc="
    #
    class Policy

      # Public: The base64 encoded policy document.
      def document
        @document ||= Base64.encode64(document_hash.to_json).gsub("\n", '')
      end

      # Public: The base64 encoded signature of the policy document. Signed
      # with the s3 access secret.
      def signature
        @signature ||= Base64.encode64(digest).gsub("\n", '')
      end

      # Public: JSON representation of the policy.
      def to_json
        { :document => document, :signature => signature }.to_json
      end

    private

      # Internal: The policy document.
      def document_hash
        { :expiration => Time.now.utc + 1.hour,
          :conditions => [
            { :bucket => bucket },
            [ 'starts-with', '$key', storage_dir ],
            { :acl => 'public-read' },
            [ 'starts-with', '$Content-Type', '' ],
            [ 'content-length-range', 0, 524288000 ]
          ]
        }
      end

      # Internal: Generates and HMAC digest of the document, signed with the
      # access secret.
      def digest
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha1'),
          secret,
          document
        )
      end

      def storage_dir
        configuration.storage_dir + '/'
      end

      def bucket
        configuration.s3_bucket
      end

      def secret
        configuration.aws_access_secret
      end

      def configuration
        ActiveAdmin::Editor.configuration
      end

    end
  end
end

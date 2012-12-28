require 'spec_helper'

describe ActiveAdmin::Editor.configuration do
  let(:configuration) { described_class }

  after do
    configuration.aws_access_key_id = nil
    configuration.aws_access_secret = nil
    configuration.s3_bucket = nil
    configuration.storage_dir = 'uploads'
  end

  context 'by default' do
    its(:aws_access_key_id) { should be_nil }
    its(:aws_access_secret) { should be_nil }
    its(:s3_bucket)         { should be_nil }
    its(:storage_dir)       { should eq 'uploads' }
  end
  
  describe '.s3_configured?' do
    subject { configuration.s3_configured? }

    context 'when not configured' do
      before do
      end

      it { should be_false }
    end
    
    context 'when key, secret and bucket are set' do
      before do
        configuration.aws_access_key_id = 'foo'
        configuration.aws_access_secret = 'bar'
        configuration.s3_bucket = 'bucket'
      end

      it { should be_true }
    end
  end

  describe '.storage_dir' do
    subject { configuration.storage_dir }

    it 'strips trailing slashes' do
      configuration.storage_dir = 'uploads/'
      expect(subject).to eq 'uploads'
    end

    it 'strips leading slashes' do
      configuration.storage_dir = '/uploads'
      expect(subject).to eq 'uploads'
    end
  end
end

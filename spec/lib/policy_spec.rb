require 'spec_helper'

describe ActiveAdmin::Editor::Policy do
  let(:configuration) { double('configuration') }

  before do
    subject.stub(:configuration).and_return(configuration)
  end

  describe '.document' do
    before do
      configuration.should_receive(:s3_bucket).and_return('bucket')
      configuration.should_receive(:storage_dir).and_return('uploads')
    end

    it 'base64 encodes the content' do
      Base64.should_receive(:encode64).and_return("foobar\n")
      expect(subject.document).to eq 'foobar'
    end

    it 'caches the document' do
      Base64.should_receive(:encode64).once.and_call_original
      2.times { subject.document }
    end
  end

  describe '.signature' do
    before do
      configuration.should_receive(:s3_bucket).and_return('bucket')
      configuration.should_receive(:storage_dir).and_return('uploads')
      configuration.should_receive(:aws_access_secret).and_return('secret')
    end

    it 'base64 encodes the content' do
      Base64.should_receive(:encode64).twice.and_return("whizbang\n")
      expect(subject.signature).to eq 'whizbang'
    end
  end

  describe '.to_json' do
    before do
      subject.stub(:document).and_return('doc')
      subject.stub(:signature).and_return('sig')
    end

    it 'should be a json representation of the document and signature' do
      expect(subject.to_json).to eq({ :document => 'doc', :signature => 'sig' }.to_json)
    end
  end
end

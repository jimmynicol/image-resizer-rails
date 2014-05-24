require 'spec_helper'

helper_class = Class.new do
  include Image::Resizer::Rails::IrHelper
end

describe 'Image::Resizer::Rails::IrHelper' do
  let(:cdn) { 'https://my.cdn.com' }
  let(:s3) { 'https://s3.amazonaws.com/sample.bucket/test/image.png' }

  subject { helper_class.new }

  context 'no configuration set' do
    it 'should throw an exception if no CDN specified' do
      -> { subject.ir_image_tag s3, s: 50 }.should raise_exception(
        Image::Resizer::Rails::NoCDNException
      )
    end
  end

  context 'configuration set' do
    before do
      Image::Resizer::Rails.configure do |config|
        config.cdn = cdn
      end
    end

    it 'should not raise an exception when no cdn set' do
      -> { subject.ir_image_tag s3, s: 50 }.should_not raise_error
    end
  end
end

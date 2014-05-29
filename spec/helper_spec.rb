require 'image/resizer/rails/helper'
require 'spec_helper'
require 'uri'

helper_class = Class.new do
  include Image::Resizer::Rails::Helper
end

describe 'Image::Resizer::Rails::Helper' do
  let(:cdn) { 'https://my.cdn.com' }
  let(:s3_obj) { '/test/image.png' }
  let(:s3) { "https://s3.amazonaws.com/sample.bucket#{s3_obj}" }
  let(:s3_inv) { "https://sample.bucket.s3.amazonaws.com#{s3_obj}" }
  let(:fb_url) { 'https://graph.facebook.com/missnine/picture' }

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
      Image::Resizer::Rails.reset_config
      Image::Resizer::Rails.configure do |config|
        config.cdn = cdn
      end
    end

    it 'should not raise an exception when cdn set' do
      -> { subject.ir_image_tag s3, s: 50 }.should_not raise_error
    end

    it 'should build an s3 url correctly' do
      subject.ir_url(s3).should eq "#{cdn}#{s3_obj}"
    end

    it 'should build an inverse s3 url correctly' do
      subject.ir_url(s3_inv).should eq "#{cdn}#{s3_obj}"
    end

    it 'should determine an s3 object correctly' do
      subject.send(:s3_object, URI(s3)).should eq s3_obj
    end

    it 'should determine an object correctly from an inverse s3 url' do
      subject.send(:s3_object, URI(s3_inv)).should eq s3_obj
    end

    it 'should detect a Facebook url and set the endpoint correctly' do
      url = "#{cdn}/efacebook/missnine.jpg"
      subject.ir_url(fb_url).should eq url
    end

    it 'should detect a Facebook url and set the modifiers correctly' do
      url = "#{cdn}/s50-efacebook/missnine.jpg"
      subject.ir_url(fb_url, s: 50).should eq url
    end

    it 'should respond to alias methods when they are set' do
      Image::Resizer::Rails.configure do |config|
        config.add_alias :ir_image_tag, :simagetag
        config.add_alias :ir_background, :sbg
        config.add_alias :ir_url, :surl
      end
      subject.should respond_to :simagetag
      subject.should respond_to :sbg
      subject.should respond_to :surl
    end

    it 'should set alias methods appropriately' do
      Image::Resizer::Rails.configure do |config|
        config.add_alias :ir_url, :surl
      end
      url = "#{cdn}/s50-efacebook/missnine.jpg"
      subject.ir_url(fb_url, s: 50).should eq url
      subject.surl(fb_url, s: 50).should eq url
    end

    context 'set modifier strings correctly' do
      it 'should set square correctly' do
        subject.ir_url(s3, s: 50).should eq "#{cdn}/s50#{s3_obj}"
      end
      it 'should set height, width correctly' do
        subject.ir_url(s3, h: 200, w: 300).should eq "#{cdn}/h200-w300#{s3_obj}"
      end
      it 'should set crop properly' do
        subject.ir_url(s3, c: 'fit').should eq "#{cdn}/cfit#{s3_obj}"
      end
      it 'should not set an invalid crop value' do
        subject.ir_url(s3, c: 'else').should_not eq "#{cdn}/celse#{s3_obj}"
      end
      it 'should set gravity properly' do
        subject.ir_url(s3, g: 'ne').should eq "#{cdn}/gne#{s3_obj}"
      end
      it 'should not set an invalid gravity value' do
        subject.ir_url(s3, g: 'else').should_not eq "#{cdn}/gelse#{s3_obj}"
      end
    end

    context 'set external source correctly' do
      it 'should set facebook when fb_uid present' do
        url = "#{cdn}/efacebook/missnine.jpg"
        subject.ir_url(fb_uid: 'missnine').should eq url
      end
      it 'should set twitter when tw_uid present' do
        url = "#{cdn}/etwitter/djmissnine.jpg"
        subject.ir_url(tw_uid: 'djmissnine').should eq url
      end
      it 'should set youtube when tw_uid present' do
        url = "#{cdn}/eyoutube/3KIZUuvnQFY.jpg"
        subject.ir_url(youtube_id: '3KIZUuvnQFY').should eq url
      end
      it 'should set vimeo when tw_uid present' do
        url = "#{cdn}/evimeo/69445362.jpg"
        subject.ir_url(vimeo_id: '69445362').should eq url
      end
    end
  end

end

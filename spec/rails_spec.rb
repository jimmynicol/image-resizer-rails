require 'spec_helper'

describe 'Image::Resizer::Rails' do
  let(:cdn) { 'https://my.cdn.com' }
  subject { Image::Resizer::Rails }

  context '#configure' do
    before do
      subject.reset_config
    end

    it 'should have no cdn set' do
      subject.cdn.should eq nil
    end

    it 'should set the cdn url' do
      subject.configure do |config|
        config.cdn = cdn
      end
      subject.cdn.should eq cdn
    end

    it 'should set a default for the js_class' do
      subject.js_class.should eq 'ImageResizer'
    end

    it 'should set the js_class' do
      subject.configure do |config|
        config.add_js_alias :js_class, 'IRAwesome'
      end
      subject.js_class.should eq 'IRAwesome'
    end

    it 'should set the js_image_tag' do
      subject.configure do |config|
        config.add_js_alias :js_image_tag, 'something_ir_tag'
      end
      subject.js_image_tag.should eq 'something_ir_tag'
    end

    it 'should set the js_background' do
      subject.configure do |config|
        config.add_js_alias :js_background, 'something_background'
      end
      subject.js_background.should eq 'something_background'
    end

    it 'should set the js_url' do
      subject.configure do |config|
        config.add_js_alias :js_url, 'something_url'
      end
      subject.js_url.should eq 'something_url'
    end

    it 'should include modifiers' do
      subject.modifiers.should include(:w, :h, :s, :c, :g, :y, :x, :e, :f)
    end

    it 'should allow adding of new modifier' do
      subject.configure do |config|
        config.add_modifier 'something', 'else'
      end

      subject.modifiers.should include(:something)
      subject.modifiers[:something][:alias].should eq 'else'
    end

    it 'should allow adding of new source' do
      subject.configure do |config|
        config.add_modifier 'something', 'else'
        config.add_source 'myspace', 'myspace_id'
      end
      subject.modifiers[:e][:values].should include(:myspace)
    end
  end

end

require 'spec_helper'

describe 'Image::Resizer::Rails' do
  let(:cdn) { 'https://my.cdn.com' }

  context '#configure' do
    subject { Image::Resizer::Rails }\

    it 'should have no cdn set' do
      subject.cdn.should eq nil
    end

    it 'should set the cdn url' do
      subject.configure do |config|
        config.cdn = cdn
      end
      subject.cdn.should eq cdn
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

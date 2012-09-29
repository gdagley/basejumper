# http://robots.thoughtbot.com/post/30994874643/testing-your-factories-first
require 'spec_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    it 'is valid' do
      instance = FactoryGirl.build(factory_name)
      instance.valid?.should be_true, instance.errors.full_messages.to_sentence
      # build(factory_name).should be_valid
    end
  end
end

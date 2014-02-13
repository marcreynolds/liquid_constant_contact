require 'spec_helper'

describe Liquid::Tags::ConstantContactCampaign do
  let(:markup) { "cc_campaign '123456'" }
  let(:tokens) { ["{% endcc_campaign %}"] }
  let(:nested) { "{{ campaign }}" }
  let(:context) { {} }
  
  def test_parse
    Liquid::Template.parse("{% #{markup} %}#{nested}{% endcc_campaign %}").render({})
  end
  
  it "has a valid syntax" do
    lambda do
      Liquid::Tags::ConstantContactCampaign.new('cc_campaign', markup, tokens, context)
    end.should_not raise_error
  end
  
  it "includes the campaign parameter" do
    ConstantContact::Api.any_instance.stub(:get_email_campaign).and_return("1234")
    test_parse.should eql("1234")
  end
  
  context "When an invalid campaign id is passed" do
    context "When invalid sytax is used" do
      it "should raise an exception" do
        markup = "cc_campaign something invalid"
        
        expect{ Liquid::Tags::ConstantContactCampaign.new('cc_campaign', markup, tokens, context)}.to raise_error
      end
    end
    it "should show an error message" do
      ConstantContact::Api.any_instance.stub(:get_email_campaign).and_raise(Liquid::Error)
      Liquid::Template.parse("{% cc_campaign '1234' %}{{ campaign }}{% endcc_campaign %}").render({}).should include("Liquid error")
    end
  end
  
end
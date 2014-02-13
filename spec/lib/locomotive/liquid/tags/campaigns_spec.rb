require 'spec_helper'

describe Liquid::Tags::ConstantContactCampaigns do
  let(:markup) { "cc_campaigns sent_to:44 limit:5" }
  let(:tokens) { ["{% endcc_campaigns %}"] }
  let(:nested) { "{{ campaigns }}" }
  let(:context) { {} }
  
  def test_parse
    Liquid::Template.parse("{% #{markup} %}#{nested}{% endcc_campaigns %}").render({})
  end
  
  it "has a valid syntax" do
    lambda do
      Liquid::Tags::ConstantContactCampaigns.new('cc_campaigns', markup, tokens, context)
    end.should_not raise_error
  end

  it "should provide information about the list campaigns" do
    ConstantContact::Api.any_instance.stub(:get_email_campaigns).and_return double(:results => [double("campaign", :id => 123, :name => "my name", :permalink_url => "http://www.goingnowhere.com", :text_content => "this is my text content").as_null_object])
    ConstantContact::Api.any_instance.stub(:get_email_campaign).and_return double("Campaign", :sent_to_contact_lists => [44]).as_null_object
    binding.pry
    result = Liquid::Template.parse("{% #{markup} %}{{ campaigns.count }}{% endcc_campaigns %}").render({})
    result.should eql("1")
  end
  
  it "should only retrieve campaigns sent to the selected list" do
    
  end
  
  it "should only retrieve up to the set limit of campaigns"
  
  it "should get up to the limit of requested campaigns even if those are later in the result set"
  
  it "should return a smaller set of campaigns if there aren't enough results present"
end
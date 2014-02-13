require 'spec_helper'

describe Liquid::Drops::LatestNewslettersDrop do
  it "should return only newsletters sent to the specified list" do
    Liquid::Drops::LatestNewslettersDrop.before_method(44)
  end
  
  def render_template(template = '', assigns = {})
    assigns = {
      'home' => @home
    }.merge(assigns)
    
    Liquid::Template.parse(template).render!(assigns)
  end
end
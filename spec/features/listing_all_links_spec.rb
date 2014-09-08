require 'spec_helper'

feature "Users browses the list of links" do

  before(:each) {
    Link.create(:url => "http://www.makersacademy.com",
                :title => "Makers Academy",
                :description => "Learn to code in 12 weeks")
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end
end

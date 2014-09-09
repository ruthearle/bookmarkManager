require 'spec_helper'

feature "Users browses the list of links" do

  before(:each) {
    Link.create(:url => "http://www.makersacademy.com",
                :title => "Makers Academy",
                :description => "Learn to code in 12 weeks",
                :tags => [Tag.first_or_create(:text => 'education')])
    Link.create(:url => "http://www.google.com",
                :title => "Google",
                :description => "Google the No. 1 search engine",
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.bing.com",
                :title => "Bing",
                :description => "Bing the No. 2 search engine",
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.code.org",
                :title => "Code.org",
                :description => "Not sure what this is but, hey!",
                :tags => [Tag.first_or_create(:text => 'education')])
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end

  scenario "filtered by tag" do
    visit '/tags/search'
    expect(page).not_to have_content("Makers Academy")
    expect(page).not_to have_content("Code.org")
    expect(page).to have_content("Google")
    expect(page).to have_content("Bing")
  end
end

require 'spec_helper'

feature "User adds a new link" do
  scenario "when browsing the homepage" do
    expect(Link.count).to eq(0)
    visit '/'
    add_link("http://www.makersacademy.com/", "Makers Academy", "Learn to code in 12 weeks")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
    expect(link.description).to eq("Learn to code in 12 weeks")
  end

  scenario "with a few tags" do
    visit "/"
    expect(Tag.all.count).to eq(0)
    add_link("http://www.makersacademy.com/",
             "Makers Academy",
             "Learn to code in 12 weeks",
             ['education', 'ruby'])
    link = Link.first
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map({|tag| tag.)text}).to include("ruby")
    expect(Tag.all.count).to eq(2)
  end

  def add_link(url, title, description, tags = [])
    within('#new-link') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'description', :with => description
      fill_in 'tags', :with => tags.join(', ')
      click_button 'Add link'
    end
  end
end

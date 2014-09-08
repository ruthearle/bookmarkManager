require 'spec_helper'

describe Link do

  context "Demonstration of how datamapper works" do

    it 'can be created and retrieved from the db' do
      expect(Link.count).to eq(0)
      Link.create(:title => "Makers Academy",
                  :url => "http://www.makersacademy.com/",
                  :description => "Learn to code in 12 weeks")
      expect(Link.count).to eq(1)
      link = Link.first
      expect(link.url).to eq("http://www.makersacademy.com/")
      expect(link.title).to eq("Makers Academy")
      expect(link.description).to eq("Learn to code in 12 weeks")
      link.destroy
      expect(Link.count).to eq(0)
    end
  end
end

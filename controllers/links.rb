post '/links' do
  url         = params["url"]
  title       = params["title"]
  description = params["description"]
  tags        = params["tags"].split(', ').map { |name| Tag.first_or_create(text: name) } #this way creates the child first 'tag' and then creates the parent 'link'

  # ['education, ruby']

  Link.create(:url         => url,
              :title       => title,
              :description => description,
              :tags        => tags)
  redirect to ('/')
end


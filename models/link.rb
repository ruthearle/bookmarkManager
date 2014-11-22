class Link

   include DataMapper::Resource #this line connects this link with a resource in data_mapper

   property :id,          Serial
   property :title,       String
   property :url,         String
   property :description, String

   has n, :tags, :through => Resource
end

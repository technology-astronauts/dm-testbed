module DB::I219
  class Post
    include DataMapper::Resource
    property :id,   Serial        
    property :name,        String
    belongs_to :user, required: false
  end

  class User
    include DataMapper::Resource
    property :id,   Serial
    has n, :posts
  end
end
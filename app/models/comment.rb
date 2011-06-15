class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content
  referenced_in :commentable, polymorphic: true
  referenced_in :author, class_name: "User"
  
  validates_presence_of :author, :content
end

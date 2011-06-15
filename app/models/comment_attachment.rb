class CommentAttachment
  include Mongoid::Document
  include Mongoid::Timestamps
  referenced_in :comment
  include AttachableModel 

  image_accessor :file
end

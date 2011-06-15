class CommentAttachment
  include Mongoid::Document
  include Mongoid::Timestamps
  referenced_in :comment
  include MongoidAjaxComments::AttachableModel 

  field :file_name
  image_accessor :file
end

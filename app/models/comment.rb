class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content
  referenced_in :commentable, polymorphic: true
  referenced_in :author, class_name: "User"
  references_many :comment_attachments, dependent: :destroy

  validates_presence_of :author, :content, :commentable
  validates :commentable_type, inclusion: MongoidAjaxComments.commentables
  attr_writer :delete_attachment_ids
  after_save :save_attachments, :delete_unwanted_attachments

  def delete_attachment_ids
    @delete_attachment_ids ||= []
  end

  def attachments_files=(some_files=[])
    @attachments_to_create = some_files.map{|a| CommentAttachment.new(file: a)}
  end

  def can_be_edited_by?(some_user)
    author == some_user
  end

  private

  def save_attachments
    if @attachments_to_create
      @attachments_to_create.each {|a| comment_attachments << a}
    end
  end

  def delete_unwanted_attachments
    delete_attachment_ids.each {|a_id| CommentAttachment.find(a_id).destroy}
  end
end

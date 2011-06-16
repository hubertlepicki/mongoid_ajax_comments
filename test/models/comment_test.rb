require 'test_helper'

class CommentTest < ActiveSupport::CleanCase
  setup do
    @article = Article.create!(title: "foo",
                              content: "bar")
    @user = User.create!(email: "w@p.pl")
  end

  test "comment should require content" do
    assert !Comment.create.errors[:content].empty?
  end

  test "comment should require author" do
    assert !Comment.create.errors[:author].empty?
  end

  test "comment should associate commentable and author" do
    comment = Comment.create(content: "Foo", author: @user, commentable: @article)
    assert comment.commentable == @article
    assert comment.author == @user
  end


  test "should create attachments when attachment_attributes are provided" do
    comment = Comment.create(content: "Foo", author: @user, commentable: @article,
     attachments_files: [
       File.new(File.join(Rails.root, "..", "fixtures", "file.txt")),
       File.new(File.join(Rails.root, "..", "fixtures", "file.txt"))
     ]
   )
   assert_equal 2, comment.comment_attachments.count
   assert_equal 2, CommentAttachment.count
  end

  test "should delete associated attachments when deleting comment" do
    comment = Comment.create(content: "Foo", author: @user, commentable: @article,
     attachments_files: [
       File.new(File.join(Rails.root, "..", "fixtures", "file.txt")),
       File.new(File.join(Rails.root, "..", "fixtures", "file.txt"))
     ]
   )
   comment.destroy
   assert_equal 0, CommentAttachment.count
  end

  test "should be possible to delete attachments by setting delete_attachment_ids array" do
    comment = Comment.create(content: "Foo", author: @user, commentable: @article,
     attachments_files: [
       File.new(File.join(Rails.root, "..", "fixtures", "file.txt")),
       File.new(File.join(Rails.root, "..", "fixtures", "file.txt"))
     ]
   )
   attachment1 = CommentAttachment.first
   attachment2 = CommentAttachment.last
   comment.update_attributes delete_attachment_ids: [attachment1.id, attachment2.id]
   assert_equal 0, CommentAttachment.count
  end

  test "edit guard by default allows edition by author only" do
    comment = Comment.create(content: "Foo", author: @user, commentable: @article)
    assert comment.can_be_edited_by?(@user)
    other_user = User.create! email: "other@user.com"
    assert !comment.can_be_edited_by?(other_user)
  end

  test "should validate allowed commentable type" do
    MongoidAjaxComments.commentables = []
    assert !Comment.create.errors[:commentable_type].empty?
    MongoidAjaxComments.commentables = ["Article"]
  end

  test "should allow custom guards" do
    MongoidAjaxComments.guards["Article"] = Proc.new do |comment, user|
      false
    end
    assert !Comment.new(commentable: @article).can_be_edited_by?(@user)

    MongoidAjaxComments.guards["Article"] = Proc.new do |comment, user|
      true
    end
    assert Comment.new(commentable: @article).can_be_edited_by?(@user)

    MongoidAjaxComments.guards["Article"] = nil
    assert Comment.new(commentable: @article).can_be_edited_by?(@user)
  end
end

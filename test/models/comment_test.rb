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


end

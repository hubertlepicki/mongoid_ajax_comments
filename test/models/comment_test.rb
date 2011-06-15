require 'test_helper'

class CommentTest < ActiveSupport::CleanCase
  setup do
    @article = Article.create(title: "foo",
                              content: "bar")
  end

  test "comment should require content" do
    assert !Comment.create.errors[:content].empty?
  end
  
  test "comment should require author" do
    assert !Comment.create.errors[:author].empty?
  end

  test "comment should associate commentable and author" do
    user = User.create(email: "sarin@wp.pl")
    comment = Comment.create(content: "Foo", author: user, commentable: @article)
    assert comment.commentable == @article
    assert comment.author == user
  end

end

require 'test_helper'

class CommentingTest < ActiveSupport::IntegrationCase
  setup do
    @article = Article.create(title: "foo",
                              content: "bar")
    @user = User.create email: "john.doe@example.com"
  end

  test "leave comment by the article" do
    visit article_path(@article, user_email: @user.email)
    click_link "Comment"
    fill_in "Content", with: "Foo bar comment"
    click_button "Post Comment"
    within ".comments" do
      assert page.has_content?("Foo bar comment")
    end
    assert !page.has_css?("#new_comment")
  end

  test "attach files while commenting" do
    visit article_path(@article, user_email: @user.email)
    click_link "Comment"
    fill_in "Content", with: "Foo bar comment"
    attach_file "Attachments", File.join(Rails.root, "..", "fixtures", "file.txt")
    click_button "Post Comment"
    assert page.has_link?("file.txt")
  end

  test "edit own comments" do
    Comment.create! content: "Foo bar",
                    commentable: @article,
                    author: @user
    visit article_path(@article, user_email: @user.email)
    click_link "Edit"
    fill_in "Content", with: "New content of old comment"
    click_button "Post Comment"
    within ".comments" do
      assert page.has_content?("New content of old comment")
    end
    assert !page.has_css?("#edit_comment")
  end

  test "remove files when editing comment" do
    Comment.create! content: "Foo bar",
                    commentable: @article,
                    author: @user,
                    attachments_files: [File.new(File.join(Rails.root, "..", "fixtures", "file.txt"))]
    visit article_path(@article, user_email: @user.email)
    click_link "Edit"
    check "remove?"
    click_button "Post Comment"
    !assert page.has_link?("file.txt")
  end

  test "remove own comments" do
    comment = Comment.create! content: "Foo bar",
                              commentable: @article,
                              author: @user
    visit article_path(@article, user_email: @user.email)

    click_link "Remove"
    assert !page.has_css?("#comment_#{comment.id}")
  end
end

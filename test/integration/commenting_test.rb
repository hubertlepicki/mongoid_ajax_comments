require 'test_helper'

class CommentingTest < ActiveSupport::IntegrationCase
  setup do
    @article = Article.create(title: "foo",
                              content: "bar")
    @user = User.create email: "john.doe@example.com"
  end

  test "can leave comment by the article" do
    visit article_path(@article)
    click_link "Comment"
    fill_in "Content", with: "Foo bar comment"
    click_button "Post Comment"
    within ".comments" do
      assert page.has_content?("Foo bar comment")
    end
    assert !page.has_css?("#new_comment")
  end

  test "can attach files while commenting" do
    visit article_path(@article)
    click_link "Comment"
    fill_in "Content", with: "Foo bar comment"
    attach_file "Attachments", File.join(Rails.root, "..", "fixtures", "file.txt")
    click_button "Post Comment"
    assert page.has_link?("file.txt")
  end
end

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
#   attach_file "Attachments", File.join(Rails.root, "..", "fixtures", "file.txt")
    click_button "Post Comment"
    within ".comments" do
      assert page.has_content?("Foo bar comment")
    end
    assert !page.has_css?("#new_comment")
#    click_link "file.txt"
#    assert page.has_content?("I am some dummy file")
  end
end

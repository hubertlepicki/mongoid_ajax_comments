class CommentsController < ApplicationController
  layout false
  before_filter :find_commentable
  helper_method :comment_post_url, :comment_post_method

  def index
    @comments = comments_for_commentable.asc(:created_at)
  end

  def new
    @comment = Comment.new commentable: @commentable, author: current_user
  end

  def create
    @comment = Comment.new(params[:comment].merge(commentable: @commentable,
                                                  author: current_user))
    unless @comment.save
      render :new
    end
  end

  def edit
    @comment = comments_for_commentable.find(params[:id])
    check_permissions
  end

  def update
    @comment = comments_for_commentable.find(params[:id])
    check_permissions
    unless @comment.update_attributes(params[:comment].merge(commentable: @commentable,
                                                       author: current_user))
      render :edit
    end
  end

  def destroy
    @comment = comments_for_commentable.find(params[:id])
    check_permissions
    @comment.destroy
  end

  def show
    @comment = comments_for_commentable.find(params[:id])
  end

  private

  def check_permissions
    raise "Not allowed" unless @comment.can_be_edited_by?(current_user)
  end

  def find_commentable
    @commentable = params[:commentable_type].classify.constantize.find(params[:commentable_id])
  end

  def comments_for_commentable
    Comment.where(commentable_type: params[:commentable_type].classify,
                  commentable_id: params[:commentable_id])
  end

  def comment_post_url(comment)
    if comment.new_record?
      comments_path(commentable_type: @comment.commentable_type.underscore,
                    commentable_id: @comment.commentable_id)
    else
      comment_path(comment,
                   commentable_type: @comment.commentable_type.underscore,
                   commentable_id: @comment.commentable_id)
    end
  end

  def comment_post_method(comment)
    comment.new_record? ? :put : :post
  end
end

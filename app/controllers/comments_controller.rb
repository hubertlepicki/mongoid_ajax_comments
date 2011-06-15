class CommentsController < ApplicationController
  layout false
  before_filter :find_commentable

  def index
    @comments = Comment.where(commentable_type: params[:commentable_type].classify,
                              commentable_id: params[:commentable_id]).asc(:created_at)
  end

  def new
    @comment = Comment.new commentable: @commentable, author: current_user
  end

  def create
    @comment = Comment.new(params[:comment].merge(commentable: @commentable, author: current_user))
    unless @comment.save      
      render :new
    end
  end

  private

  def find_commentable
    @commentable = params[:commentable_type].classify.constantize.find(params[:commentable_id])
  end
end

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :commentable_exists!

  def create
    @comment = Comment.new(create_params)
    if @comment.save
      redirect_to(request.env['HTTP_REFERER'] + "#comment-#{@comment.id}")
    else
      flash[:alert] = "Error creating a comment"
      redirect_to :back
    end
  end

  def destroy
    @comment = Comment.where(shared_params).find(params[:id])
    authorize! :destroy, @comment
    if @comment.destroy
      flash[:notice] = "Comment was succesfully deleted"
      redirect_to(request.env['HTTP_REFERER'])
    else
      flash[:alert] = "Error deleting comment"
      redirect_to :back
    end
  end

  private
  # Ensure that commentable model exists
  def commentable_exists!
    @commentable = shared_params[:commentable_type].safe_constantize&.find(shared_params[:commentable_id])
    raise ActiveRecord::RecordNotFound if @commentable.blank?
  end

  def create_params
    @create_params ||= shared_params.merge(profile_params).merge(comment_params)
  end

  def comment_params
    @comment_params ||= params.require(:comment).permit(:text)
  end

  def profile_params
    @profile_params ||= {
      profile_id: current_profile.id
    }
  end

  def shared_params
    @shared_params ||= {
      commentable_id:   params.require(:commentable_id),
      commentable_type: params.require(:commentable_type).to_s.camelize
    }
  end
end

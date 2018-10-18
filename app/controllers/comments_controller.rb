class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      message = "Comment was successfully created."
    else
      flash[:comment_error] = @comment.errors.full_messages
      message = "Comment wasn't created"
    end
    redirect_to movie_path(comment_params[:movie_id]), notice: message
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to movie_path(comment.movie_id), notice: "Comment was successfully destroyed."
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :movie_id)
  end
end

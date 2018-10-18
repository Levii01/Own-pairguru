class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if current_user.has_role?(:spamer) && comment_exists?
      return redirect_to_movie("Your comment already exists")
    end

    if @comment.save
      redirect_to_movie("Comment was successfully created.")
    else
      flash[:comment_error] = @comment.errors.full_messages
      redirect_to_movie("Comment wasn't created")
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to movie_path(comment.movie_id), notice: "Comment was successfully destroyed."
  end

  private

  def redirect_to_movie(notice)
    redirect_to movie_path(comment_params[:movie_id]), notice: notice
  end

  def comment_exists?
    Comment.exists?(movie_id: comment_params[:movie_id], user_id: current_user.id)
  end

  def comment_params
    @comment_params ||= params.require(:comment).permit(:body, :user_id, :movie_id)
  end
end

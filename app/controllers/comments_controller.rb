class CommentsController < ApplicationController
  def create
    response = CommentServices::CreateComment.call(params, current_user)
    flash[:comment_error] = response[:flash] if response[:flash]
    redirect_to_movie(response[:movie_id], response[:message])
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to_movie(comment.movie_id, "Comment was successfully destroyed.")
  end

  def ranking
    @top_users = CommentServices::TopCustomers.call
  end

  private

  def redirect_to_movie(movie_id, message)
    redirect_to movie_path(movie_id), notice: message
  end
end

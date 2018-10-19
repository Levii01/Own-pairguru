module CommentServices
  class CreateComment < ApplicationService
    def call(params, current_user)
      comment_params(params, current_user)
      comment = Comment.new(@comment_params)

      create_comment(comment)
    end

    def create_comment(comment)
      return response("Your comment already exists") if user_spamer? && comment_exists?
      return response("Comment was successfully created.") if comment.save
      response("Comment wasn't created", comment.errors.full_messages)
    end

    def user_spamer?
      @current_user.has_role?(:spamer)
    end

    def response(message, flash = nil)
      { movie_id: @comment_params[:movie_id], message: message, flash: flash }
    end

    def comment_exists?
      Comment.exists?(movie_id: @comment_params[:movie_id], user_id: @current_user.id)
    end

    def comment_params(params, current_user)
      @comment_params = params.require(:comment).permit(:body, :user_id, :movie_id)
      @current_user = current_user
    end
  end
end

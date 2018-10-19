module CommentServices
  class TopCustomers < ApplicationService
    def call
      query
    end

    def query
      Comment.includes(:user).group(:user_id)
        .where("comments.updated_at >= ?", 7.days.ago.beginning_of_day)
        .reorder("coments_counted DESC").limit(10)
        .pluck_to_hash(:email, 'count("comments.id") AS coments_counted')
    end
  end
end

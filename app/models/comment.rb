class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :body, :movie_id, :user_id, presence: true
end

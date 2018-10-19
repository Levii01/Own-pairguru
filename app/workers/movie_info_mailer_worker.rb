class MovieInfoMailerWorker
  include Sidekiq::Worker

  def perform(user_id, movie_id)
    MovieInfoMailer.send_info(user_id, movie_id).deliver_now
  end
end

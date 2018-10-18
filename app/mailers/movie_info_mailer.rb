class MovieInfoMailer < ApplicationMailer
  def send_info(user_id, movie_id)
    @movie = Movie.find(movie_id)
    user = User.find(user_id)
    sleep(3) # this emulates long email sending, do not remove
    mail(to: user.email, subject: "Info about movie #{@movie.title}")
  end
end

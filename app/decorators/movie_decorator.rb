class MovieDecorator < Draper::Decorator
  delegate_all

  def poster(poster_path)
    Rails.configuration.movie_api_url + poster_path
  end
end

class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    "http://lorempixel.com/100/150/" +
      %w[abstract nightlife transport].sample +
      "?a=" + SecureRandom.uuid
  end

  def poster(poster_path)
    return cover if poster_path.blank?
    Rails.configuration.movie_api_url + poster_path
  end
end

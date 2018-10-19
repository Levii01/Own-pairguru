class GenresController < ApplicationController
  def index
    @genres = Genre.all
    @movies_counted = Genre.includes(:movies).group("movies.genre_id")
                           .pluck(:id, 'count("movies.id")').to_h
  end

  def movies
    @genre = Genre.find(params[:id]).decorate
    @movies = @genre.movies
    @movies_data = MovieServices::FetchMoviesData.call(@genre.movies) if @movies.any?
  end
end

class GenresController < ApplicationController
  def index
    @genres = Genre.all.decorate
  end

  def movies
    @genre = Genre.find(params[:id]).decorate
    @movies = @genre.movies
    @movies_data = MovieServices::FetchMoviesData.call(@genre.movies) if @movies.any?
  end
end

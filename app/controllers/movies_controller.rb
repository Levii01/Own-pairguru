class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all.decorate
    @movies_data = MovieServices::FetchMoviesData.call(@movies)
  end

  def show
    @movie = Movie.find(params[:id])
    @movie_data = MovieServices::GetMovieData.call(@movie.title)
    @comments = @movie.comments
    @comment = Comment.new
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailerWorker.perform_async(current_user.id, @movie.id)
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporterWorker.perform_async(current_user.id, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end

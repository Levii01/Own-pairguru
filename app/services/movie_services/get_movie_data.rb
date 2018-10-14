require 'net/http'

module MovieServices
  class GetMovieData < ApplicationService
    include Dry::Monads::Do.for(:call)

    def call(movie)
      request = yield create_request_url(movie.title)
      response = yield get_movie_data(request)
      parse_movie_attributes(response)
    end

    def create_request_url(title)
      Success(get_url(title))
    end

    def get_movie_data(request)
      Success(Net::HTTP.get(request))
    end

    def parse_movie_attributes(response)
      response = JSON.parse(response)

      Success(parse_response(response))
    end

    def get_url(movie_name)
      URI.parse("#{Rails.configuration.movie_api_url}/api/v1/movies/#{movie_name}")
    end

    def parse_response(response)
      response['data']['attributes'].with_indifferent_access
    end
  end
end


RSpec.describe MoviesController, type: :controller do
  let!(:movie) { create(:movie, title: "Kill Bill 2") }

  describe "GET index", vcr: { cassette_name: "services/get_movie_data/success" } do
    it "renders the index template" do
      get :index
      expect(response.status).to eq 200
    end
  end

  describe "GET show", vcr: { cassette_name: "services/get_movie_data/success" } do
    it "renders the index template" do
      get :show, params: { id: movie.id }
      expect(response.status).to eq 200
    end
  end
end

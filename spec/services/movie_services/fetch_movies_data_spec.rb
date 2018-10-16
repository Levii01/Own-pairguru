RSpec.describe MovieServices::FetchMoviesData do
  subject { described_class.call(movies) }

  context "when fetches data for 3 movies",
          vcr: { cassette_name: 'services/fetch_movies_data/3_movies_success' } do
    let!(:movie_1) { create(:movie, title: "Kill Bill 2") }
    let!(:movie_2) { create(:movie, title: "Deffpool") }
    let!(:movie_3) { create(:movie, title: "Django") }
    let(:movies) { [movie_1, movie_2, movie_3] }

    let(:result_movie_1) { subject[1] }
    let(:result_movie_2) { subject[2] }
    let(:result_movie_3) { subject[3] }

    it "returns correct number of movies data" do
      expect(subject.size).to eq(3)
    end

    it "returns correct movie_1 data" do
      expect(result_movie_1[:title]).to eq(movie_1.title)
      expect(result_movie_1[:poster]).to eq("/kill_bill_2.jpg")
      expect(result_movie_1[:rating]).to eq(8.0)
    end

    it "returns empty hash for movie_2" do
      expect(result_movie_2).to eq({})
    end

    it "returns correct movie_3 data" do
      expect(result_movie_3[:title]).to eq(movie_3.title)
      expect(result_movie_3[:poster]).to eq("/django.jpg")
      expect(result_movie_3[:rating]).to eq(8.4)
    end
  end

  context "when fetches data for no movies" do
    let(:movies) { [] }

    it "returns empty hash" do
      expect(subject).to eq({})
    end
  end
end

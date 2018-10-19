RSpec.describe Api::GraphqlController do
  let(:genre_1) { create(:genre, name: "Action") }
  let(:genre_2) { create(:genre, name: "Western") }

  let!(:movie_1) { create(:movie, title: "Kill Bill 2", genre: genre_1) }
  let!(:movie_2) { create(:movie, title: "Deffpool", genre: genre_1) }
  let!(:movie_3) { create(:movie, title: "Django", genre: genre_2) }

  let(:graphql_result) do
    [{ "id" => "1",
       "title" => "Kill Bill 2",
       "genre" => { "id" => "1", "name" => "Action", "numberOfMovies" => 2 } },
     { "id" => "2",
       "title" => "Deffpool",
       "genre" => { "id" => "1", "name" => "Action", "numberOfMovies" => 2 } },
     { "id" => "3",
       "title" => "Django",
       "genre" => { "id" => "2", "name" => "Western", "numberOfMovies" => 1 } }]
  end
  let(:params) { { query: "{ movies { id title genre { id name numberOfMovies } } }" } }
  let(:response_body) { JSON.parse(subject.body).with_indifferent_access }

  describe "POST #execute" do
    subject { post :execute, params: params }

    context "when call to graphql for all movies" do
      it { expect(subject).to have_http_status(200) }

      it "returns json with 3 movies" do
        expect(response_body[:data]).to include(:movies)
        expect(response_body[:data][:movies].size).to eq(3)
      end

      it "returns correct movies data" do
        expect(response_body[:data][:movies]).to eq(graphql_result)
      end
    end

    context "when call to graphql for one movie" do
      let(:params) { { query: "{ movies(id: 2) { id title} }" } }

      it { expect(subject).to have_http_status(200) }

      it "returns json with 1 movie" do
        expect(response_body[:data]).to include(:movies)
        expect(response_body[:data][:movies].size).to eq(1)
      end

      it "returns correct movie data" do
        expect(response_body[:data][:movies][0]).to eq("id" => "2", "title" => "Deffpool")
      end
    end

    context "when send wrong query" do
      let(:params) { { query: "{ movies { id title XgenreX { id name numberOfMovies } } }" } }

      it { expect(subject).to have_http_status(200) }

      it "returns error wit description" do
        expect(response_body).to include(:errors)
        expect(response_body[:errors][0][:message]).to eq("Field 'XgenreX' doesn't exist on type 'Movie'")
      end
    end
  end

  describe "GET #execute" do
    subject { get :execute, params: params }

    context "when call to graphql" do
      it { expect(subject).to have_http_status(200) }

      it "returns json with 3 movies" do
        expect(response_body[:data]).to include(:movies)
        expect(response_body[:data][:movies].size).to eq(3)
      end

      it "returns correct movies data" do
        expect(response_body[:data][:movies]).to eq(graphql_result)
      end
    end

    context "when call to graphql for one movie" do
      let(:params) { { query: "{ movies(id: #{movie_2.id}) { id title genre { id name numberOfMovies } } }" } }
      let(:qraphql_result) do
        { "id" => "2",
          "title" => "Deffpool",
          "genre" => { "id" => "1", "name" => "Action", "numberOfMovies" => 2 } }
      end

      it { expect(subject).to have_http_status(200) }

      it "returns correct movie data" do
        expect(response_body[:data][:movies][0]).to eq(qraphql_result)
      end
    end

    context "when send wrong query" do
      let(:params) { { query: "{ movies(id: #{movie_2.id}) { id titleXX genre { id name numberOfMovies } } }" } }

      it { expect(subject).to have_http_status(200) }

      it "returns error wit description" do
        expect(response_body).to include(:errors)
        expect(response_body[:errors][0][:message]).to eq("Field 'titleXX' doesn't exist on type 'Movie'")
      end
    end
  end
end

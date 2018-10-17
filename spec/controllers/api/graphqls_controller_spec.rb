RSpec.describe Api::GraphqlController do
  let!(:movie_1) { create(:movie, title: "Kill Bill 2") }
  let!(:movie_2) { create(:movie, title: "Deffpool") }
  let!(:movie_3) { create(:movie, title: "Django") }

  let(:graphql_result) do
    [{ "id" => "1", "title" => "Kill Bill 2" },
     { "id" => "2", "title" => "Deffpool" },
     { "id" => "3", "title" => "Django" }]
  end
  let(:params) { { query: "{ movies { id title} }" } }
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
  end
end

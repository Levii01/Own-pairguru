RSpec.describe MovieServices::TopCustomers do
  subject { described_class.call(movie.title) }

  context "when sends correct movie titie via api" do
    let(:movie) { create(:movie, title: "Kill Bill 2") }

    it "returns movie data hash" do
      expect(subject).to include(:title, :poster, :plot, :rating)
      expect(subject[:poster]).to eq("/kill_bill_2.jpg")
      expect(subject[:title]).to eq(movie.title)
      expect(subject[:rating]).to eq(8.0)
    end

    it "returns correct number of keys" do
      expect(subject.size).to eq(4)
    end
  end
]
end

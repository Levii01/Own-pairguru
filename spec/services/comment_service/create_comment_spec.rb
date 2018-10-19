RSpec.describe CommentServices::CreateComment do
  def controller_params(params)
    ActionController::Parameters.new(params)
  end

  let(:movie) { create(:movie) }
  let(:user) { create(:user) }

  let(:valid_attributes) do
    controller_params({ comment: { body: "Test comment", movie_id: movie.id, user_id: user.id } })
  end
  let(:invalid_attributes) do
    controller_params({ comment: { body: "", movie_id: movie.id, user_id: user.id } })
  end

  subject { described_class.call(valid_attributes, user) }

  describe "create comment" do
    context "when valid params" do
      it "creates a new Comment" do
        expect { subject }.to change(Comment, :count).by(1)
      end

      it "returns corect data" do
        expect(subject[:movie_id]).to eq(movie.id)
        expect(subject[:message]).to eq("Comment was successfully created.")
        expect(subject[:flash]).to eq(nil)
      end
    end

    context "when invalid params" do
      subject { described_class.call(invalid_attributes, user) }

      it "creates a new Comment" do
        expect { subject }.to change(Comment, :count).by(0)
      end

      it "returns error description" do
        expect(subject[:movie_id]).to eq(movie.id)
        expect(subject[:message]).to eq("Comment wasn't created")
        expect(subject[:flash]).to eq(["Body can't be blank"])
      end
    end

    describe "user with spamer role" do
      let!(:comment) { create(:comment, user: user, movie: movie) }

      context "when spamer try to add second comment" do
        before { user.add_role :spamer }

        it "not creates a new Comment" do
          expect { subject }.to change(Comment, :count).by(0)
        end

        it "returns error description" do
          expect(subject[:movie_id]).to eq(movie.id)
          expect(subject[:message]).to eq("Your comment already exists")
          expect(subject[:flash]).to eq(nil)
        end
      end

      context "when not spamer try to add second comment" do
        it "creates a new Comment" do
          expect { subject }.to change(Comment, :count).by(1)
        end
      end
    end
  end
end

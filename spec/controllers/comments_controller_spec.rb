RSpec.describe CommentsController, type: :controller do
  let(:movie) { create(:movie) }
  let(:user) { create(:user) }

  let(:valid_attributes) { { body: "Test comment", movie_id: movie.id, user_id: user.id } }
  let(:invalid_attributes) { { body: "", movie_id: movie.id, user_id: user.id } }

  before { sign_in(user) }

  describe "POST #create" do
    context "when valid params" do
      subject { post :create, params: { comment: valid_attributes } }

      it "creates a new Comment" do
        expect { subject }.to change(Comment, :count).by(1)
      end

      it "redirects to the movie show page" do
        subject
        expect(response.code).to eq("302")
        expect(response).to redirect_to(movie)
      end
    end

    context "when invalid params" do
      subject { post :create, params: { comment: invalid_attributes } }

      it "creates a new Comment" do
        expect { subject }.to change(Comment, :count).by(0)
      end

      it "redirects to the movie show page" do
        subject
        expect(response.code).to eq("302")
        expect(response).to redirect_to(movie)
      end
    end

    context "when spamer try to add second comment" do
      let!(:comment) { create(:comment, user: user, movie: movie) }

      subject { post :create, params: { comment: valid_attributes } }

      it "not creates a new Comment" do
        user.add_role :spamer

        expect { subject }.to change(Comment, :count).by(0)
      end
    end

    context "when not spamer try to add second comment" do
      let!(:comment) { create(:comment, user: user, movie: movie) }

      subject { post :create, params: { comment: valid_attributes } }

      it "creates a new Comment" do
        expect { subject }.to change(Comment, :count).by(1)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment) }

    subject { delete :destroy, params: { id: comment.id } }

    it "destroys the requested comment" do
      expect { subject }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      subject
      expect(response).to redirect_to(comment.movie)
    end
  end

  describe "GET ranking" do
    it "renders the ranking template" do
      get :ranking
      expect(response.status).to eq 200
    end
  end
end

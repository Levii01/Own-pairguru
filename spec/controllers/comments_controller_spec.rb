RSpec.describe CommentsController, type: :controller do
  let(:movie) { create(:movie) }
  let(:user) { create(:user) }

  let(:valid_attributes) {
    { body: "Test comment", movie_id: movie.id, user_id: user.id }
  }
  let(:invalid_attributes) { { body: "", movie_id: movie.id, user_id: user.id } }

  describe "POST #create" do
    context "with valid params" do
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

    context "with invalid params" do
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
end

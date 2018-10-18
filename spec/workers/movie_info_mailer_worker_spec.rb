require "rails_helper"
require "sidekiq/testing"

RSpec.describe MovieInfoMailerWorker, type: :worker do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }

  after { Sidekiq::Worker.clear_all }

  context "when send job to worker" do
    it "changes jobs queue size by one" do
      expect { MovieInfoMailerWorker.perform_async(user.id, movie.id) }
        .to change(MovieInfoMailerWorker.jobs, :size).by(1)
    end
  end
end

require "rails_helper"
require "sidekiq/testing"

RSpec.describe MovieExporterWorker, type: :worker do
  let(:user) { create(:user) }
  let!(:movie) { create(:movie) }
  let(:file_path) { "tmp/movies.csv" }

  after { Sidekiq::Worker.clear_all }

  context "when send job to worker" do
    it "changes jobs queue size by one" do
      expect { MovieExporterWorker.perform_async(user.id, file_path) }
        .to change(MovieExporterWorker.jobs, :size).by(1)
    end
  end
end

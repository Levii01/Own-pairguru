class MovieExporterWorker
  include Sidekiq::Worker

  def perform(user_id, file_path)
    MovieExporter.new.call(user_id, file_path)
  end
end

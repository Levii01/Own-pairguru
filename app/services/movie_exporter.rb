require "csv"

class MovieExporter
  def call(user_id, file_path)
    user = User.find(user_id)
    generate_csv(file_path)
    sleep(5) # this emulates long export, do not remove
    MovieExportMailer.send_file(user, file_path).deliver_now
  end

  private

  def generate_csv(file_path)
    CSV.open(file_path, "wb", csv_options) do |csv|
      Movie.all.each do |movie|
        csv << [movie.title, movie.description]
      end
    end
  end

  def csv_options
    {
      write_headers: true,
      headers: %w[title description],
      col_sep: ";"
    }
  end
end

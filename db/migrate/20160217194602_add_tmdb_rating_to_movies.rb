class AddTmdbRatingToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tmdb_rating, :decimal
  end
end

class Movie < ActiveRecord::Base

  include Tmdbapi

  before_save :get_tmdb_title,
  :get_tmdb_poster_url,
  :get_tmdb_director, :get_tmdb_overview,
  :get_tmdb_release_date,
  :get_tmdb_vote_average, if: :tmdb_result

  scope :search, ->(query) {where("title like ? OR director like ? OR description like ?", "%#{query}%", "%#{query}%", "%#{query}%")}

  has_many :reviews

  mount_uploader :image, ImageUploader

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :release_date,
    presence: true

  def review_average
    return 0 if reviews.size == 0
    reviews.sum(:rating_out_of_ten)/reviews.size
  end

  def average_rating
    @average_rating ||= reviews.average(:rating_out_of_ten).to_f.round()
  end

  def latest_reviews(count=3)
    reviews.order(:created_at).limit(count).includes(:user)
  end

  private

  def tmdb_result
    @tmdb_result = Movie.find_by_title(self.title)
    get_tmdb_id
    @tmdb_result
  end

  def get_tmdb_id
    if @tmdb_result
      self.tmdb_id = @tmdb_result.id
    end
  end

  def get_tmdb_title
    self.title = tmdb_result.title
  end

  def get_tmdb_poster_url
    self.poster_image_url = "#{Movie::POSTER}#{tmdb_result.poster_path}"
  end

  def get_tmdb_director
    unless Tmdb::Movie.director(self.tmdb_id).empty?
      self.director = Tmdb::Movie.director(self.tmdb_id).first.name
    end
  end

  def get_tmdb_overview
    self.description = tmdb_result.overview
  end

  def get_tmdb_release_date
    self.release_date = tmdb_result.release_date
  end

  def get_tmdb_vote_average
    self.tmdb_rating = tmdb_result.vote_average
  end
end

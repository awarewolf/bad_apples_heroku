class Movie < ActiveRecord::Base

  include Tmdbapi

  before_create :add_poster_image_url

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

  def add_poster_image_url
    results = Movie.find_by_title(self.title)
    return nil if results.empty?
    self.poster_image_url = "#{Movie::POSTER}#{results.first.poster_path}"
  end

end

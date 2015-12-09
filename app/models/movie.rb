class Movie < ActiveRecord::Base

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

end

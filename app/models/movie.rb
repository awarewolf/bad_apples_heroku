class Movie < ActiveRecord::Base

  include Tmdbapi
  # TODO Verify which callback is best to reduce tmdb API calls
  before_validation :get_tmdb_title,
  :get_tmdb_poster_url,
  :get_tmdb_director,
  :get_tmdb_overview,
  :get_tmdb_release_date,
  :get_tmdb_runtime, if: :tmdb_result

  scope :search, lambda { |query|
    # Searches the movies table on the 'title', 'director' and 'description' columns.
    # Matches using LIKE, automatically appends '%' to each term.
    # LIKE is case INsensitive with MySQL, however it is case
    # sensitive with PostGreSQL. To make it work in both worlds,
    # we downcase everything.
    return nil if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    # TODO Search could be better?
    terms = terms.map { |e|
      # (e.gsub('*', '%') + '%').gsub(/%+/, '%')
      ('%' + e + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 3
    where(terms.map { |term| "(LOWER(title) LIKE ? OR LOWER(director) LIKE ? OR LOWER(description) LIKE ?)" }.
      join(' AND '),*terms.map { |e| [e] * num_or_conds }.flatten)
  }

  has_many :reviews

  mount_uploader :image, ImageUploader

  validates :title,
    presence: true

  # validates :director,
  #   presence: true

  # validates :runtime_in_minutes,
  #   numericality: { only_integer: true }

  # validates :description,
  #   presence: true

  validates :release_date,
    presence: true

  validates :tmdb_id, presence: true

  validates :tmdb_id, uniqueness: true

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

  def tmdb_vote_average
    tmdb_result.vote_average
  end

  def tmdb_vote_count
    tmdb_result.vote_count
  end

  private

  def tmdb_result
    @tmdb_result ||= Movie.find_by_title(self.title)
    get_tmdb_id
    ap @tmdb_result
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
    if tmdb_result.poster_path
      self.poster_image_url = "#{Movie::POSTER}#{tmdb_result.poster_path}"
    else
      self.poster_image_url = nil
    end
  end

  def get_tmdb_director
    director = Tmdb::Movie.director(self.tmdb_id)
    unless director.empty?
      self.director = director.first.name
    end
  end

  def get_tmdb_overview
    self.description = tmdb_result.overview
  end

  def get_tmdb_release_date
    self.release_date = tmdb_result.release_date
  end

  def get_tmdb_runtime
    self.runtime_in_minutes = Tmdb::Movie.detail(self.tmdb_id).runtime
  end
end

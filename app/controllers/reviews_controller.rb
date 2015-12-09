 class ReviewsController < ApplicationController

  before_filter :restrict_access
  before_filter :set_review

  def index
    @reviews = movie.reviews.all
  end

  def new
    @review = @movie.reviews.build
  end

  def create
    @review = movie.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      redirect_to @movie, notice: "Review created successfully"
    else
      render :new
    end
  end

  private

  def movie
    @movie ||= Movie.find(params[:movie_id])
  end

  def set_review
    @review ||= movie.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:text, :rating_out_of_ten)
  end

end
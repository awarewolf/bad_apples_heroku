# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require './lib/tasks/movies_importer'

User.delete_all

User.create!(firstname: 'site', lastname: 'admin', email: 'siteadmin@example.com', password: '123456', admin: true, email_confirmed: true)

10.times do
  User.create!(firstname: FFaker::Name.first_name, lastname: FFaker::Name.last_name, email: FFaker::Internet.email, password: '123456', email_confirmed: true)
end

@user_ids = User.all.pluck(:id)

Movie.delete_all
Review.delete_all

def create_movies(tmdb_list)
  tmdb_list.results.each do |selected_movie|
    movie = Movie.new
    movie.title = selected_movie.title
    # movie.seeding = true
    # binding.pry
    # movie.save!(validate: false)
    if movie.valid?
      movie.save!
      sleep(1)
      puts "#{movie.title} created!"
      rand(1..10).times do
        movie.reviews.create!(text: FFaker::BaconIpsum.sentences.join(" "),
          rating_out_of_ten: plausible_rating(selected_movie),
          user_id: @user_ids.sample)
      end
    end
  end
end

def plausible_rating(movie)
  # binding.pry
  rating = (rand(-2..2) + movie.vote_average).round
  if rating > 10
    10
  elsif rating < 1
    1
  else
    rating
  end
end

create_movies(Tmdb::Movie.upcoming)
create_movies(Tmdb::Movie.now_playing)
create_movies(Tmdb::Movie.popular)
create_movies(Tmdb::Movie.top_rated)
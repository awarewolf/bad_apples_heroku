# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require './lib/tasks/movies_importer'

Faker = FFaker

User.delete_all

User.create!(firstname: 'site', lastname: 'admin', email: 'siteadmin@example.com', password: '123456', admin: true, email_confirmed: true)

10.times do
  User.create!(firstname: Faker::Name.first_name, lastname: Faker::Name.last_name, email: Faker::Internet.email, password: '123456', email_confirmed: true)
end

user_ids = User.all.pluck(:id)

Movie.delete_all
Review.delete_all

top_movies = Tmdb::Movie.top_rated

top_movies.results.each do |top_rated_movie|
  movie = Movie.new
  movie.title = top_rated_movie.title
  movie.save!(validate: false)
  sleep(1)
  puts "#{movie.title} created!"
  rand(0..10).times do
    movie.reviews.create!(text: Faker::BaconIpsum.sentences.join(" ") , rating_out_of_ten: rand(1..10), user_id: user_ids.sample)
  end
end

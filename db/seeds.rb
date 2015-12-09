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

User.create!(firstname: 'site', lastname: 'admin', email: 'siteadmin@example.com', password: '123456', admin: true)

10.times do
  User.create!(firstname: Faker::Name.first_name, lastname: Faker::Name.last_name, email: Faker::Internet.email, password: Faker::Internet.password)
end

user_ids = User.all.pluck(:id)

Movie.delete_all
Review.delete_all

50.times do |count|
  movie = Movie.create!(
    title: Faker::Movie.title,
    director: Faker::Name.name,
    runtime_in_minutes: rand(90..160),
    release_date: rand(32289).days.ago.to_date,
    # image: open("http://lorempixel.com/400/600/"),
    description: Faker::DizzleIpsum.paragraphs.join(" ")
  )
  rand(0..30).times do
    movie.reviews.create!(text: Faker::BaconIpsum.sentences.join(" ") , rating_out_of_ten: rand(1..10), user_id: user_ids.sample)
  end
end

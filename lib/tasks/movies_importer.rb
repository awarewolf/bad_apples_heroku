# class MoviesImporter

#   def initialize(filename=File.dirname(__FILE__) + "/../../db/data/movies.csv")
#     @filename = filename
#   end

#   def import
#     field_names = ['title', 'director', 'runtime_in_minutes', 'description', 'release_date']

#     print "Importing movies from #{@filename}: "
#     failure_count = 0

#       File.open(@filename).each do |line|
#         data = line.chomp.split(',')
#         attribute_hash = Hash[field_names.zip(data)]
#         begin
#           movie = Movie.create!(attribute_hash)
#           print "."; STDOUT.flush
#         rescue ActiveRecord::UnknownAttributeError => ex
#           puts ex
#           print "!"; STDOUT.flush
#           failure_count += 1
#         end
#       end

#     failures = "(failed to create #{failure_count} movie records)" if failure_count > 0
#     puts "\nDONE #{failures}\n\n"
#   end

# end
module Tmdbapi
  extend ActiveSupport::Concern

  attr_reader :get_configuration, :images, :base_url, :poster_size

  POSTER_SIZE = 6 # See http://docs.themoviedb.apiary.io {6 for original}

  included do
    @@configuration = self.get_configuration
    @@base_url = self.images('base_url')
    @@poster_size = "#{@@base_url}#{self.images('poster_sizes', POSTER_SIZE)}"
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

    def find_by_title(title)
      Tmdb::Search.movie(title).results
    end

    # private

    def get_configuration
      Tmdb::Configuration.get
    end

    def images(parameter, *index)
      if index.empty?
        @@configuration.images.send(parameter.to_sym)
      else
        @@configuration.images.send(parameter.to_sym[index[0]])
      end
    end
  end
end

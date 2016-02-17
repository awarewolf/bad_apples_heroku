module Tmdbapi
  extend ActiveSupport::Concern

  attr_reader :get_configuration, :images, :base_url, :poster_size

  POSTER_SIZE_INDEX = 2 # See http://docs.themoviedb.apiary.io {6 for original}

  included do
      CONFIGURATION = self.get_configuration
      BASE_URL = self.images('base_url')
      POSTER = "#{BASE_URL}#{poster_size(POSTER_SIZE_INDEX)}"
  end

  module InstanceMethods

    # def get_director
    #   Tmdb::Movie.director(self.tmdb_id).first.name
    # end

  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

    def find_by_title(title)
      Tmdb::Search.movie(title, adult: false).results.first
    end

    # private

    def get_configuration
      Tmdb::Configuration.get
    end

    def images(parameter, *index)
      if index.empty?
        CONFIGURATION.images.send(parameter.to_sym)
      else
        CONFIGURATION.images.send(parameter.to_sym)[index[0]]
      end
    end

    def poster_size(index)
      self.images('poster_sizes', index)
    end

    # def get_director
    #   Tmdb::Movie.director(@movie.id).first.name
    # end
  end
end

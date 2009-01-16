module Micronaut
  module Rails
    module Version
      MAJOR = 0
      MINOR = 2
      TINY  = 0
      MINISCULE = 0
      
      STRING = [MAJOR, MINOR, TINY, MINISCULE].join('.')

      MICRONAUT_VERSION = [MAJOR, MINOR, TINY].join('.')
      MICRONAUT_VERSION_STRING = "~> #{MICRONAUT_VERSION}"
    end
  end
end

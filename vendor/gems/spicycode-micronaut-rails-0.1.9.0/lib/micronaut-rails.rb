require 'action_controller'
require 'action_controller/test_process'
require 'micronaut/rails/configuration'
require 'micronaut/rails/matchers/controllers/redirect_to'
require 'micronaut/rails/matchers/controllers/render_template'
require 'micronaut/rails/transactional_database_support'
require 'micronaut/rails/version'
require 'micronaut/rails/helpers'
require 'micronaut/rails/controllers'
require 'micronaut/rails/extensions/active_record'
require 'micronaut/rails/mocking/model_stubber'

module Micronaut
  module Rails
    class IllegalDataAccessException < StandardError; end

  end

end
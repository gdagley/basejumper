# http://jessewolgamott.com/blog/2012/01/19/the-one-with-a-json-api-login-using-devise/

class Api::BaseApiController < ApplicationController
  respond_to :json
end
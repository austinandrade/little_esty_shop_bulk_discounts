class ApplicationController < ActionController::Base
  def welcome
    render html: "Welcome to adopt don't shop!"
  end
end

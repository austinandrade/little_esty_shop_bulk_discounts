class ApplicationController < ActionController::Base
  def welcome
    render html: "Welcome to adopt don't shop!"
  end

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end

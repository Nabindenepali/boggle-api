class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include BoggleError

  def speller
    SPELLER
  end
end

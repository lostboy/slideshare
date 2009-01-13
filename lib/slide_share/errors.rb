module SlideShare
  # Raised when API method requires username and password but none
  # was provided
  class InsufficientPermission < StandardError; end
  
  # Raised when API method was given incorrect username and/or password
  class FailedUserAuthentication < StandardError; end
  
  # Raised when no slideshow matches the supplied slideshow_id
  class SlideshowNotFound < StandardError; end
  
  # Raised when the application has made more than 1000 calls a day
  class AccountExceededDailyLimit < StandardError; end
  
  # Raised when none of the other errors match
  class ServiceError < StandardError; end
end
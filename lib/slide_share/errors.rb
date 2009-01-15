module SlideShare
  # Root error
  # Raised when none of the other errors match
  class ServiceError < StandardError; end
  
  # Raised when API method requires username and password but none
  # was provided
  class InsufficientPermission < ServiceError; end
  
  # Raised when API method was given incorrect username and/or password
  class FailedUserAuthentication < ServiceError; end
  
  # Raised when no slideshow matches the supplied slideshow_id
  class SlideshowNotFound < ServiceError; end
  
  # Raised when the application has made more than 1000 calls a day
  class AccountExceededDailyLimit < ServiceError; end
end
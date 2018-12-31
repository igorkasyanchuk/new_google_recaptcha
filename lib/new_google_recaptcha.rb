require "new_google_recaptcha/railtie"

module NewGoogleRecaptcha
  mattr_accessor :site_key
  mattr_accessor :secret_key

  def self.setup
    yield(self)
  end

  def self.human?(token, minimum_score, action, model = nil)
    is_valid = NewGoogleRecaptcha::Validator.valid?(token, minimum_score, action)
    if model && !is_valid
      model.errors.add(:base, "Looks like you are not a human")
    end
    is_valid
  end
end

require_relative "new_google_recaptcha/view_ext"
require_relative "new_google_recaptcha/validator"
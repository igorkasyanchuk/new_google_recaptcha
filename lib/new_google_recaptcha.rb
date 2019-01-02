require "new_google_recaptcha/railtie"

module NewGoogleRecaptcha
  mattr_accessor :site_key
  mattr_accessor :secret_key
  mattr_accessor :minimum_score

  def self.setup
    yield(self)
  end

  def self.human?(token, action, minimum_score = self.minimum_score, model = nil)
    is_valid = NewGoogleRecaptcha::Validator.valid?(token, action, minimum_score)
    if model && !is_valid
      model.errors.add(:base, self.i18n("new_google_recaptcha.errors.verification_human", "Looks like you are not a human"))
    end
    is_valid
  end

  def self.i18n(key, default)
    if defined?(I18n)
      I18n.translate(key, default: default)
    else
      default
    end
  end

end

require_relative "new_google_recaptcha/view_ext"
require_relative "new_google_recaptcha/validator"
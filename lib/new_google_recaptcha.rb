require "new_google_recaptcha/railtie"

module NewGoogleRecaptcha
  mattr_accessor :site_key
  mattr_accessor :secret_key
  mattr_accessor :minimum_score

  def self.setup
    yield(self)
  end

  def self.human?(token, action, minimum_score = self.minimum_score, model = nil)
    is_valid =
      NewGoogleRecaptcha::Validator.new(
        token: token,
        action: action,
        minimum_score: minimum_score
      ).call

    if model && !is_valid
      model.errors.add(:base, self.i18n("new_google_recaptcha.errors.verification_human", "Looks like you are not a human"))
    end

    is_valid
  end

  def self.get_humanity_detailed(token, action, minimum_score = self.minimum_score, model = nil)
    validator =
      NewGoogleRecaptcha::Validator.new(
        token: token,
        action: action,
        minimum_score: minimum_score
      )

    is_valid = validator.call

    if model && !is_valid
      model.errors.add(:base, self.i18n("new_google_recaptcha.errors.verification_human", "Looks like you are not a human"))
    end

    { is_human: is_valid, actual_score: validator.actual_score }
  end

  def self.i18n(key, default)
    if defined?(I18n)
      I18n.translate(key, default: default)
    else
      default
    end
  end

  def self.compose_uri(token)
    URI(
      "https://www.google.com/recaptcha/api/siteverify?"\
      "secret=#{self.secret_key}&response=#{token}"
    )
  end
end

require_relative "new_google_recaptcha/view_ext"
require_relative "new_google_recaptcha/validator"

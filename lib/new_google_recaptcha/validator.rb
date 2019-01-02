require 'net/http'

module NewGoogleRecaptcha
  class Validator
    def self.valid?(token, action, minimum_score)
      uri    = URI("https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response=#{token}")
      result = JSON.parse(Net::HTTP.get(uri))
      conditions = []
      conditions << !!result['success']
      conditions << (result['score'].to_f >= minimum_score)
      conditions << (result['action'].to_s == action.to_s)
      conditions.none?(&:!)
    end
  end
end

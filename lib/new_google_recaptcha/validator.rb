require 'net/http'

module NewGoogleRecaptcha
  class Validator
    
    def Validator.valid?(token)
      uri    = URI("https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response=#{token}")
      result = JSON.parse(Net::HTTP.get(uri))
      !!result["success"]
    end

  end
end

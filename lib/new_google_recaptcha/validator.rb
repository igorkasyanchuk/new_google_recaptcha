require 'net/http'

module NewGoogleRecaptcha
  class Validator
    attr_reader :actual_score

    def initialize(token:, action:, minimum_score:)
      @token = token
      @action = action
      @minimum_score = minimum_score
    end

    def call
      uri    = NewGoogleRecaptcha.compose_uri(@token)
      result = JSON.parse(Net::HTTP.get(uri))

      @actual_score = result['score'].to_f

      conditions = []
      conditions << !!result['success']
      conditions << (result['score'].to_f >= @minimum_score)
      conditions << (result['action'].to_s == @action.to_s)
      conditions.none?(&:!)
    end
  end
end

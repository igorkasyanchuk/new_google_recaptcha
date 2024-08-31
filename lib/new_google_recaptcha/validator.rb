require 'net/http'

module NewGoogleRecaptcha
  class Validator
    attr_reader :score, :result, :actions_match
    attr_reader :token, :action, :minimum_score

    def initialize(token:, action:, minimum_score:)
      @token         = token
      @action        = action
      @minimum_score = minimum_score
    end

    def call
      uri = NewGoogleRecaptcha.compose_uri(token)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      @result = JSON.parse(http.request(Net::HTTP::Get.new(uri)).body)

      @score = @result['score'].to_f

      @result__success = @result['success']
      result__action = @result['action'].to_s

      @score_bigger_than_minimum = @score >= minimum_score
      @actions_match = result__action == action.to_s

      @result__success && @score_bigger_than_minimum && @actions_match
    end
  end
end

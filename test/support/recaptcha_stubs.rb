def stub_post_recaptcha_success
  stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
  ).to_return(
      status: 200,
      body: {
          "success": true,
          "challenge_ts": "2018-12-31T15:36:25Z",
          "hostname": "localhost",
          "score": 0.9,
          "action": "manage_posts"
      }.to_json,
      headers: {}
  )
end

def stub_post_recaptcha_fail_score
  stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
  ).to_return(
      status: 200,
      body: {
          "success": false,
          "challenge_ts": "2018-12-31T15:36:25Z",
          "hostname": "localhost",
          "score": 0.0,
          "action": "manage_posts"
      }.to_json,
      headers: {}
  )
end

def stub_post_recaptcha_fail_action
  stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
  ).to_return(
      status: 200,
      body: {
          "success": false,
          "challenge_ts": "2018-12-31T15:36:25Z",
          "hostname": "localhost",
          "score": 0.9,
          "action": ""
      }.to_json,
      headers: {}
  )
end

def stub_book_recaptcha_success
  stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
  ).to_return(
      status: 200,
      body: {
          "success": true,
          "challenge_ts": "2018-12-31T15:36:25Z",
          "hostname": "localhost",
          "score": 0.9,
          "action": "manage_books"
      }.to_json,
      headers: {}
  )
end

def stub_book_recaptcha_fail_score
  stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
  ).to_return(
      status: 200,
      body: {
          "success": false,
          "challenge_ts": "2018-12-31T15:36:25Z",
          "hostname": "localhost",
          "score": 0.0,
          "action": "manage_books"
      }.to_json,
      headers: {}
  )
end

def stub_book_recaptcha_fail_action
  stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
  ).to_return(
      status: 200,
      body: {
          "success": false,
          "challenge_ts": "2018-12-31T15:36:25Z",
          "hostname": "localhost",
          "score": 0.9,
          "action": ""
      }.to_json,
      headers: {}
  )
end
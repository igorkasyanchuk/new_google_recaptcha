module NewGoogleRecaptcha
  module ViewExt
    include ActionView::Helpers::TagHelper

    def include_recaptcha_js
      raw %Q{
        <script src="https://www.google.com/recaptcha/api.js?render=#{NewGoogleRecaptcha.site_key}"></script>
      }
    end

    def recaptcha_action(action)
      id = "new_google_recaptcha_token_#{SecureRandom.hex(10)}"
      raw %Q{
        <input name="new_google_recaptcha_token" type="hidden" id="#{id}"/>
        <script>
          grecaptcha.ready(function() {
            grecaptcha.execute("#{NewGoogleRecaptcha.site_key}", {action: "#{action}"}).then(function(token) {
              document.getElementById("#{id}").value = token;
            });
          });
        </script>
      }
    end
  end
end
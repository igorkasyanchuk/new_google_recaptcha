module NewGoogleRecaptcha
  module ViewExt
    include ActionView::Helpers::TagHelper

    def include_recaptcha_js(opts = {})
      badge = opts[:badge] ? "&badge=#{opts[:badge]}" : ""
      generate_recaptcha_callback +
        javascript_include_tag(
          "https://www.google.com/recaptcha/api.js?render=#{NewGoogleRecaptcha.site_key}&onload=newGoogleRecaptchaCallback#{badge}",
          defer: true
        )
    end

    def recaptcha_action(action)
      id = "new_google_recaptcha_token_#{SecureRandom.hex(10)}"
      hidden_field_tag(
        'new_google_recaptcha_token',
        nil,
        readonly: true,
        'data-google-recaptcha-action' => action,
        id: id
      )
    end

    private

    def generate_recaptcha_callback
      javascript_tag %(
        function newGoogleRecaptchaCallback () {
          grecaptcha.ready(function () {
            var elements = document.querySelectorAll('[data-google-recaptcha-action]')
            Array.prototype.slice.call(elements).forEach(function (el) {
              var action = el.dataset.googleRecaptchaAction
              if (!action) return
              grecaptcha
                .execute("#{NewGoogleRecaptcha.site_key}", { action: action })
                .then(function (token) {
                  el.value = token
                })
            })
          })
        }
      )
    end
  end
end

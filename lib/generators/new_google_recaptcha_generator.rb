class NewGoogleRecaptchaGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def copy_initializer
    template 'new_google_recaptcha.rb', 'config/initializers/new_google_recaptcha.rb'
  end
end
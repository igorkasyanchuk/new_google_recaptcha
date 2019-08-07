# Google Recaptcha v3 + Rails

Integrate Google Recaptcha v3 with Rails app.

Google Recaptcha console: https://www.google.com/recaptcha/admin#list

Recaptcha v3 documentation: https://developers.google.com/recaptcha/docs/v3

## Usage

- Open https://www.google.com/recaptcha/admin#list
- register a new site
- copy `site_key` and `secret_key` and put into config/initializers/new_google_recaptcha.rb
- optionally, change the `minimum_score` in the initializer to a preferred float value (from 0.0 to 1.0)
- in layout:
  ```erb
  <head>
    ...
    <%= yield :recaptcha_js %>
  </head>
  ```
- in view where you for example you have a form:
  ```erb
  <%= content_for :recaptcha_js do %>
    <%= include_recaptcha_js %>
  <% end %>
  <form ...>
    <%#= 'checkout' is action name to be verified later %>
    <%= recaptcha_action('checkout') %>
  </form>
  ```
- in controller:
  ```ruby
  def create
    @post = Post.new(post_params)
    if NewGoogleRecaptcha.human?(
        params[:new_google_recaptcha_token],
        "checkout",
        NewGoogleRecaptcha.minimum_score,
        @post
      ) && @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end
  ```
  or
  ```ruby
  def create
    @post = Post.new(post_params)
    humanity_details =
      NewGoogleRecaptcha.get_humanity_detailed(
        params[:new_google_recaptcha_token],
        "checkout",
        NewGoogleRecaptcha.minimum_score,
        @post
      )

    @post.humanity_score = humanity_details[:actual_score]

    if humanity_details[:is_human] && @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end
  ```

There are two mandatory arguments for `human?` method:

- `token` - token valid for your site
- `action` - the action name for this request
  (the gem checks if it is the same as the name used with the token,
  otherwise a hacker could replace it on frontend to some another action used,
  but with lower score requirement and thus pass the verification)

You can verify recaptcha without using these arguments:

- `minimum_score` - defaults to value set in the initializer
  (reCAPTCHA recommends using 0.5 as default)
- `model` - defaults to `nil` which will result in not adding an error to model;
  any custom failure handling is applicable here

like this:

```ruby
  NewGoogleRecaptcha.human?(params[:new_google_recaptcha_token], "checkout")
```

`get_humanity_detailed` method acts like `human?` method,
the only difference is that it returns following hash with two key-value pairs:
- `is_human` - whether actor is a human or not (same as result of `human?` method)
- `actual_score` - actual humanity score from recaptcha response

It could be handy if you want to store score in db or put it into logs or smth else.

Add to your navigation links `data-turbolinks="false"` to make it works with `turbolinks`.

## Installation

```ruby
gem 'new_google_recaptcha'
```

And then execute:
```bash
$ bundle
```

And then run:

```bash
$ rails generate new_google_recaptcha initializer
```

And edit new_google_recaptcha.rb and enter your site_key and secret_key.

## API

`NewGoogleRecaptcha.human?(token, model)` or `NewGoogleRecaptcha.get_humanity_detailed(token, model)` in contoller

- token is received from google, must be sent to backend
- model optional parameter. if you want to add error to model.

`<%= include_recaptcha_js %>` in layout (by using yield)

Include Google Recaptcha v3 JS into your Rails app. In head, right before `</head>`.

`<%= recaptcha_action(action_name) %>` in view

Action where recaptcha action was executed. Actions could be viewed in Admin console. More docs: https://developers.google.com/recaptcha/docs/v3. Action name could be "comments", "checkout", etc. Put any name and check scores in console.

## How to add to devise

Generate Devise controllers and views, and edit "create" method.

```ruby
class Users::RegistrationsController < Devise::RegistrationsController
...
  def create
    build_resource(sign_up_params)

    NewGoogleRecaptcha.human?(
      params[:new_google_recaptcha_token],
      "user",
      NewGoogleRecaptcha.minimum_score,
      resource) && resource.save

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
```

## How to use in test or specs

At the end of the spec/rails_helper.rb put:

```ruby
module NewGoogleRecaptcha
  def self.human?(*attrs)
    true
  end
end
```


## I18n support
reCAPTCHA passes one types of error explanation to a linked model. It will use the I18n gem
to translate the default error message if I18n is available. To customize the messages to your locale,
add these keys to your I18n backend:

`new_google_recaptcha.errors.verification_human` error message displayed when it is something like a robot, or a suspicious action

Also you can translate API response errors to human friendly by adding translations to the locale (`config/locales/en.yml`):

```Yaml
en:
  new_google_recaptcha:
    errors:
      verification_human: 'Fail'
```

## TODO

- check everything works with turbolinks
- allow custom ID for input
- return score ?
- more tests
- handle exceptions with timeouts, json is not parsed
- add support for non-Rails apps
- add support for older Rails (should be easy since code is very simple)

## Contributors

You are welcome to contribute.

* [Igor Kasyanchuk](https://github.com/igorkasyanchuk) (maintainer)
* [gilcierweb](https://github.com/gilcierweb)
* [RoRElessar](https://github.com/RoRElessar)
* [rubyconvict](https://github.com/rubyconvict)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

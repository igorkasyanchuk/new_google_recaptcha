# Google Recaptcha v3 + Rails

Integrate Google Recaptcha v3 with Rails app. 

Google Recaptcha console: https://www.google.com/recaptcha/admin#list

Recaptcha v3 documentation: https://developers.google.com/recaptcha/docs/v3

## Usage

- Open https://www.google.com/recaptcha/admin#list
- register a new site
- copy `site_key` and `secret_key` and put into config/initializer/new_google_recaptcha.rb
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
    <%= recaptcha_action('checkout') %>
  </form>
  ```
- in controller:
  ```ruby
  def create
    @post = Post.new(post_params)
    if NewGoogleRecaptcha.human?(params[:new_google_recaptcha_token], @post) && @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end
  ```

Also you can verify token without adding error to model:

```ruby
  NewGoogleRecaptcha.human?(params[:new_google_recaptcha_token])
```

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

**NewGoogleRecaptcha.human?(token, model)** in contoller

- token is received from google, must be sent to backend
- model optional parameter. if you want to add error to model.

**<%= include_recaptcha_js %>** in layout (by using yield)

Include Google Recaptcha v3 JS into your Rails app. In head, right before `</head>`.

**<%= recaptcha_action(action_name) %>** in view

Action where recaptcha action was executed. Actions could be viewed in Admin console. More docs: https://developers.google.com/recaptcha/docs/v3. Action name could be "comments", "checkout", etc. Put any name and check scores in console.

## TODO

- check everything works with turbolinks
- allow custom ID for input
- return score ?
- tests
- handle exceptions with timeouts, json is not parsed
- add support for non-Rails apps
- add support for older Rails (should be easy since code is very simple)

## Contributing

You are welcome to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

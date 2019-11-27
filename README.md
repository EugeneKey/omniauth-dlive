# OmniAuth::Dlive
OmniAuth strategy for Dlive

## Installation
Add this line to your application's Gemfile:

    gem 'omniauth-dlive'

Then run `bundle install`

Or install it yourself with `gem install omniauth-dlive`

### Using Directly
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dlive, ENV['DLIVE_CLIENT_ID'], ENV['DLIVE_CLIENT_SECRET']
end
```

### Using With Devise
Add to `config/initializers/devise.rb`
```ruby
  config.omniauth :dlive, ENV['DLIVE_CLIENT_ID'], ENV['DLIVE_CLIENT_SECRET']
```

And apply it to your Devise user model:
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable,
         omniauth_providers: %i(dlive)

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
      u.password = Devise.friendly_token[0, 20]
      u.provider = auth.provider
      u.uid      = auth.uid
    end
    user.update avatar_url: auth.info.image,
                email:      auth.info.email,
                name:       auth.info.name
    user
  end
end
```

## Default Scope

The default scope is set to _email:read_, making this hash available in `request.env['omniauth.auth']`:

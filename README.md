# MissingText
---

MissingText is a rails engine for detecting missing translations from your locale files. The web interface allows full visiblity of missing translations by file, allowing you to revisit and clear sessions.

## Installing 
---

To install the gem:

``` 
$ gem install 'missing_text'
```

Add it to the gemfile `development` and rebundle.

``` 
group :development do
	gem 'missing_text'
end
```
Next run migrations in order to create the database records

```
$ rake missing_text:install:migrations
```

Next we need to create the initializer for MissingText. This will be installed in `config/initializers/missing_text.rb`. This file can be edited to change startup options.

```
$ rails generate initializer missing_text
```

Finally we need to mount the engine in `routes.rb`

```
Example::Application.routes.draw do
  root :to => 'home#index'

  mount MissingText::Engine => '/missing_text' if Rails.env.development?
end
```

## Running MissingText outside of Development?
---

**It is strongly recommended that you install MissingText in the development group of your Gemfile, or only direct to address in your routes file if you are in the development environment.**

_However_, if you wish to have your MissingText accessible outside of development, you can control your access by overriding the controller like so:

```
class MyController < MissingText::DiffController
	before_action :some_authenication_method
end
``` 

Where you can perform any user authorization or setup if you choose.


## Configuration Options
---

* `MissingText.locale_root` - The directory where all of the locale files live. An additional directory can be specified if your locales are in a location other than the default `config/locales/`. This is a relative path and will be appended to `Rails.root`.
* `MissingText.skip_directories` - Include any directories in `MissingText.locale_root` that you would like to skip. By default this will be appended to `.` and `..`. Please make these paths relative to your `MissingText.locale_root`. This is an empty array by default.
* `MissingText.search_direct_locale`- Include the search of the locale root itself (e.g. `config/locales`) when looking for missing translations. This is true by default.

## Development and Contribution
---

I would love to have others contribute. Email me at `chris.sandison@gmail.com` if you have questions, suggestions, or want to discuss. Otherwise, you know the drill:

1. Fork it (https://github.com/ChrisSandison/missing_text/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git push origin my-new-feature`)
4. Create a new Pull Request

Please feel free to create issues if you find any bugs and I will respond as best as I can.


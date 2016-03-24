# Fotofetch

Arguments for fetch_links method are: search value, optional number of links returned,
and optional dimension restrictions (width, height).
If a dimension argument is positive, it will look for pictures larger than that,
and if the number is negative, results will be restricted to those smaller than that.
Initiate an instance to use: @fetcher = Fotofetch::Fetch.new
The fetch_links method will return results like: http:example.com/image.jpg)
To find a 1 small photo of Jupiter, call @fetcher.fetch_links("jupiter", 1, -500, -500).
To find 3 large photos of Jupiter, call @fetcher.fetch_links("jupiter", 3, 1500, 1500).
To grab just the first provided photo, call @fetcher.fetch_links("jupiter").
If a small or large enough image is not found, dimension restrictions will be disregarded.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fotofetch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fotofetch

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/steveoscar/fotofetch.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

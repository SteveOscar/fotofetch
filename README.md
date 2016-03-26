# Fotofetch

This gem allows the simple searching for and saving of images to your app. Various photo-searching API's will provide more consistent results, but this is a quick way to find images matching a query. Results can be restricted by photo dimensions and batch-saved to your directory. This gem was extracted from an app to fetch movie posters for a movie suggestion [site](http://www.nonshittymovies.com), which dynamically creates the content on each page load.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fotofetch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fotofetch

## Basic Usage  

- Initiate an instance of Fotofetch:  
```ruby
@fetcher = Fotofetch::Fetch.new
```
- To fetch an image of a Tesla Model S:
```ruby
link = @fetcher.fetch_links("tesla model s")
```  
- To save the link to your file directory (links must be in an array, so call .values):
```ruby
@ff.save_images(link.values, './')
```  
The 'save_images' method takes two arguments: link(s) and the file path for where to save. File names are gerated from the previous query, so if you search for 2 images of 'red_ball', they will be saved as 'red_ball_0.jpg' and 'red_ball_1.jpg'.

## More Specific Queries
Arguments for the 'fetch_links' method are: search value (required), number of links returned (optional), and two dimension restrictions arguments (optional: width, height).  

If a dimension argument is positive, it will look for pictures larger than that,
and if the number is negative, results will be restricted to those smaller than that. Note that adding dimensions restrictions to your query will slow it down.

- To find a 1 small photo of Jupiter less than 500px x 500px:
```ruby
@fetcher.fetch_links("jupiter", 1, -500, -500)
```
To find 3 large photos of Jupiter:
```ruby
links = @fetcher.fetch_links("jupiter", 3, 1500, 1500)
```
And to save all of those links:
```ruby
@fetcher.save_images(links.values, './')
```
If a small or large enough image is not found, dimension restrictions will be disregarded.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/steveoscar/fotofetch.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

#### Me
(http://www.stevenoscarolson.com)

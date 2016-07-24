require 'fotofetch/version'
require 'mechanize'
require 'open-uri'
require 'fastimage'

module Fotofetch
  class Fetch
    attr_accessor :options

    def default_options
      { amount: 1,
        width: 9999,
        height: 9999,
        search_url: "http://www.bing.com/images/search?q=" }
    end

    def fetch_links(topic, amount=default_options[:amount],
      width=default_options[:width], height=default_options[:height])
      @topic = topic
      create_options(amount, width, height)

      page = scrape(@topic)
      urls = pluck_urls(page)
      imgs = pluck_imgs(urls)
      imgs = restrict_dimensions(imgs, self.options)
      results = add_sources(imgs)
    end

    def create_options(amount, width, height)
      self.options = default_options.merge({
        amount: amount,
        width: width,
        height: height
      })
    end

    def scrape(topic)
      Mechanize.new.get(self.options[:search_url] + topic)
    end

    def pluck_urls(page)
      page.links.map { |link| link.href } # gathers all urls.
    end

    def image_link?(link)
      link.include?(".jpg") || link.include?(".png")
    end

    def pluck_imgs(urls)
      urls.select { |link| image_link?(link) }
    end

    def custom_restrictions?(options)
      (options[:width] != default_options[:width]) ||
      (options[:height] != default_options[:height])
    end

    def restrict_dimensions(urls, options)
      return urls.take(options[:amount]) if !custom_restrictions?(options)

      urls.each_with_object([]) do |link, size_checked|
        dimensions = link_dimensions(link)
        next if dimensions == [0, 0]
        return size_checked if size_checked.length >= options[:amount]
        size_checked << link if size_ok?(dimensions, options)
      end
    end

    def size_ok?(dimensions, options)
      sizes = [[options[:width], options[:height]], dimensions]
      width_ok?(sizes) && height_ok?(sizes)
    end

    def width_ok?(sizes)
      width = sizes[1][0] - sizes[0][0]
      (0 < width && width < sizes[1][0]) || width > (sizes[1][0] * 2)
    end

    def height_ok?(sizes)
      height = sizes[1][1] - sizes[0][1]
      (0 < height && height < sizes[1][1]) || height > (sizes[1][1] * 2)
    end

    def root_url(link)
      link.split("/")[2]
    end

    # Adds root urls as hash keys
    def add_sources(urls)
      urls.each_with_object( {}.compare_by_identity ) do |link, pairs|
        pairs[root_url(link)] = link
      end
    end

    # takes an array of links
    def save_images(urls, file_path)
      urls.each_with_index do |url, i|
        open("#{@topic.gsub(' ', '-')}_#{i}.jpg", 'wb') do |file|
          file << open(url).read
        end
      end
    end

    def link_dimensions(link)
      # nil from FastImate will return [0,0] which means non-direct-image link
      FastImage.size(link) || [0,0]
    end
  end
end

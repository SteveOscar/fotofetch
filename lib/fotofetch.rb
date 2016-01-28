require "fotofetch/version"
require 'mechanize'
require 'open-uri'
require 'fastimage'

module Fotofetch
  class Fetch

    # arguments for method are: search value, number of links returned, and dimension restrictions.
    # if a dimension argument is positive, it will look for pictures larger than that,
    # and if the number is negative, results will be restricted to those smaller than that.
    def fetch_links(topic, amount=1, width= +9999, height= +9999)
      scrape(topic, amount, width, height)
    end

    def scrape(topic, amount, width, height)
      agent = Mechanize.new
      page = agent.get("http://www.bing.com/images/search?q=#{topic}")
      pluck_urls(page, amount, width, height)
    end

    def pluck_urls(page, amount, width, height)
      urls = []
      page.links.each { |link| urls << link.href } # gathers all urls.
      pluck_jpgs(urls, amount, width, height)
    end

    def pluck_jpgs(urls, amount, width, height)
      urls = (urls.select { |link| link.include?(".jpg") }) # keeps only .jpg urls.
      (urls = restrict_dimensions(urls, width, height)) if restrictions?(width, height)
      urls = urls[0..(amount-1)] # selects only number of links desired, default is 1.
      add_sources(urls)
    end

    def restrictions?(width, height)
      (width != 9999 || height!= 9999) ? true : false
    end

    def restrict_dimensions(urls, width, height)
      if width.abs == width && height.abs == height
        urls.select { |link| width_check(width, link, :>) && height_check(height, link, :>) }
      elsif width.abs != width && height.abs != height
        urls.select { |link| width_check(width, link, :<) && height_check(height, link, :<) }
      elsif width.abs == width && height.abs != height
        urls.select { |link| width_check(width, link, :>) && height_check(height, link, :<) }
      else
        urls.select { |link| width_check(width, link, :<) && height_check(height, link, :>) }
      end
    end

    def width?(width)
      width != 9999
    end

    def width_check(width, link, operator)
      (width?(width) ? ((check_size(link)[0]).send(operator, width)) : true)
    end

    def height?(height)
      height != 9999
    end

    def height_check(height, link, operator)
      (height?(height) ? ((check_size(link)[1]).send(operator, height)) : true)
    end

    def add_sources(urls)
      results = {}.compare_by_identity
      urls.each { |link| results[link.split("/")[2]] = link} # adds sources as hash keys
      results
    end

    # takes an array of links
    def save_images(urls, file_path)
      urls.each_with_index do |url, i|
        open("image_#{i}.jpg", 'wb') do |file|
          file << open(url).read
        end
      end
    end

    def check_size(link)
      size = FastImage.size(link)
      size.nil? ? [0, 0] : size
    end

  end
end

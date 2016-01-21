require "fotofetch/version"
require 'mechanize'
require 'open-uri'
require 'fastimage'


module Fotofetch
  class Fetch

    # arguments for method are: search value, links returned, and include sources?
    def fetch_links(topic, amount=1)
      scrape(topic, amount)
    end

    def scrape(topic, amount)
      agent = Mechanize.new
      page = agent.get("http://www.bing.com/images/search?q=#{topic}")
      pluck_urls(page, amount)
    end

    def pluck_urls(page, amount)
      urls = []
      page.links.each { |link| urls << link.href } # gathers all urls
      pluck_jpgs(urls, amount)
    end

    def pluck_jpgs(urls, amount)
      urls = (urls.select { |link| link.include?(".jpg") })[0..(amount-1)] # keeps only .jpg urls
      add_sources(urls)
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
      FastImage.size(link)
    end

  end
end

require "fotofetch/version"
require 'mechanize'
require 'open-uri'
require 'fastimage'


module Fotofetch
  class Fetch

    # arguments for method are: search value, links returned, and include sources?
    def fetch_links(topic, amount=1, sources=false)
      urls = []
      results = {}.compare_by_identity
      agent = Mechanize.new
      page = agent.get("http://www.bing.com/images/search?q=#{topic}")
      page.links.each { |link| urls << link.href } # gathers all urls
      urls = (urls.select { |link| link.include?(".jpg") })[0..(amount-1)] # keeps only .jpg urls
      urls.each { |link| results[link.split("/")[2]] = link} # adds sources as hash keys
      results
    end

    def with_sources(urls, results)

    end

    # non-source keys are simply indices to keep the method's class type return consistent
    def no_sources(urls, results)
      Hash[(0...urls.size).zip urls]
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

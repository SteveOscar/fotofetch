require "fotofetch/version"
require 'mechanize'
require 'open-uri'


module Fotofetch
  class Fetch
    def fetch_images(topic, amount=1, sources=false)
      links = []
      results = {}.compare_by_identity
      agent = Mechanize.new
      page = agent.get("http://www.bing.com/images/search?q=#{topic}")
      page.links.each { |link| links << link.href } # gathers all links
      links = (links.select { |link| link.include?(".jpg") })[0..(amount-1)] # keeps only .jpg links
      if sources
        links.each { |link| results[link.split("/")[2]] = link} # adds sources as hash keys
      else
        results = Hash[(0...links.size).zip links]
      end
      results
      byebug
    end

    def save_images

    end

  end
end

require 'fotofetch/version'
require 'mechanize'
require 'open-uri'
require 'fastimage'

module Fotofetch
  class Fetch
    def fetch_links(topic, amount=1, width= +9999, height= +9999)
      @query = topic
      @results = []
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
      pluck_imgs(urls, amount, width, height)
    end

    def pluck_imgs(urls, amount, width, height)
      urls = (urls.select { |link| link.include?(".jpg") || link.include?(".png") })
      restrict_dimensions(urls, width, height, amount) if restrictions?(width, height)
      @results = urls if @results.empty?
      urls = @results[0..(amount-1)]
      add_sources(urls)
    end

    def restrictions?(width, height)
      (width != 9999 || height!= 9999) ? true : false
    end

    def restrict_dimensions(urls, width, height, amount)
      urls.each do |link|
        select_links(link, width, height) unless @results.length >= amount
      end
    end

    def select_links(link, width, height)
      # Two arrays: first is dimension restrictions, 2nd is link dimensions.
      sizes = [[width, height], link_dimensions(link)]
      unless link_dimensions(link) == [0, 0] # Throws out non-direct-image links
        @results << link if width_ok?(sizes) && height_ok?(sizes)
      end
    end

    def width_ok?(sizes)
      width = sizes[1][0] - sizes[0][0]
      (0 < width && width < sizes[1][0]) || width > (sizes[1][0] * 2)
    end

    def height_ok?(sizes)
      height = sizes[1][1] - sizes[0][1]
      (0 < height && height < sizes[1][1]) || height > (sizes[1][1] * 2)
    end

    # Adds root urls as hash keys
    def add_sources(urls)
      results = {}.compare_by_identity
      urls.each { |link| results[link.split("/")[2]] = link}
      results
    end

    # takes an array of links
    def save_images(urls, file_path)
      urls.each_with_index do |url, i|
        open("#{@query.gsub(' ', '-')}_#{i}.jpg", 'wb') do |file|
          file << open(url).read
        end
      end
    end

    def link_dimensions(link)
      size = FastImage.size(link)
      size.nil? ? [0, 0] : size
    end
  end
end

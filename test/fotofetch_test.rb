require 'test_helper'
require 'byebug'

class FotofetchTest < Minitest::Test

  def setup
    @fetch = Fotofetch::Fetch.new
  end
  def test_that_it_has_a_version_number
    refute_nil ::Fotofetch::VERSION
  end

  def test_it_finds_image_links

    links = @fetch.fetch_images("tesla model s", 5)

    assert_equal 5, links.count
  end

  def test_it_only_saves_sources_for_links_if_requested
    link = @fetch.fetch_images("mars", 2, true)
    refute link[:source].nil?
  end


end

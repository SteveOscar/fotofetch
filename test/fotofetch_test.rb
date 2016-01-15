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
    links = @fetch.fetch_links("tesla model s", 5)

    assert_equal 5, links.count
    assert links.first[1].include?('.jpg')
  end

  def test_it_only_saves_sources_for_links_if_requested
    link = @fetch.fetch_links("mars", 1, true)
    refute link.keys[0] == 0

    link = @fetch.fetch_links("mars", 1)
    assert link.keys[0] == 0
  end

  def test_it_can_save_an_image
    link = @fetch.fetch_links("mars", 1, true).values
    @fetch.save_images(link, './')
    assert  File.exist?('image_0.jpg')
  end


end

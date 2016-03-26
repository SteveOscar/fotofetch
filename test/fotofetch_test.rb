require 'test_helper'
require 'byebug'

class FotofetchTest < Minitest::Test

  def setup
    @ff = Fotofetch::Fetch.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::Fotofetch::VERSION
  end

  def test_it_finds_image_links
    links = @ff.fetch_links("tesla model s", 5)

    assert_equal 5, links.count
    assert links.first[1].include?('.jpg') || links.first[1].include?('.png')
  end

  def test_it_saves_sources_for_links
    link = @ff.fetch_links("mars", 1)
    source = link.values.first.split("/")[2]

    assert_equal source, link.keys.first
  end

  def test_it_can_save_an_image
    link = @ff.fetch_links("tesla", 1).values
    @ff.save_images(link, './')

    assert  File.exist?('tesla_0.jpg')
    refute  File.zero?('tesla_0.jpg')
    File.delete('tesla_0.jpg')
  end

  def test_it_checks_image_size
    link = @ff.fetch_links("mars", 1).values
    dimensions = @ff.link_dimensions(link.first)

    assert_equal 2, dimensions.count
  end

  def test_it_validates_dimensions
    sizes = [[-900, 900], [1000, 1000]]
    assert_equal false, @ff.width_ok?(sizes)
    assert_equal true, @ff.height_ok?(sizes)

    sizes = [[-900, 900], [950, 800]]
    assert_equal false, @ff.width_ok?(sizes)
    assert_equal false, @ff.height_ok?(sizes)

    sizes = [[900, -900], [1000, 800]]
    assert_equal true, @ff.width_ok?(sizes)
    assert_equal true, @ff.height_ok?(sizes)

    sizes = [[-900, 900], [800, 800]]
    assert_equal true, @ff.width_ok?(sizes)
    assert_equal false, @ff.height_ok?(sizes)

    sizes = [[-900, -900], [800, 800]]
    assert_equal true, @ff.width_ok?(sizes)
    assert_equal true, @ff.height_ok?(sizes)
  end

  def test_it_can_restrict_image_dimensions
    link = @ff.fetch_links("mars", 1, 1000, 1000).values
    big = @ff.link_dimensions(link.first)[0]

    restricted_link = @ff.fetch_links("tesla", 1, -900, -900).values
    small = @ff.link_dimensions(restricted_link.first)[0]

    difference = big - small
    assert (difference > 100)

    restricted_link = @ff.fetch_links("tesla", 1, -900, -900).values
    size = @ff.link_dimensions(restricted_link.first)

    assert size[0] < 900
    assert size[1] < 900
  end

  def test_if_dimensions_are_disregarded_if_no_matches_found
    link = @ff.fetch_links("mars", 1, 10000, 10000).values
    assert link

    link = @ff.fetch_links("mars", 1, -2, -2).values
    assert link
  end

end

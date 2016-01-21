rake for tests
uses fastimage to check for image size

methods:

fetch_links(topic, amount?, source?) returns an array of relevant photo links
  links = fetch_links('tesla', 2, true)

save_images(urls, filepath)
  save_images(links, './')

# Dribble Set Tag
#
# Generates image galleries from player's recent shots with customizable
# shots per page and which page of results to render 
#
# Usage:
#
#   {% dribbble_set user:username shots_per_page:# page:# %}
#
# Example:
#
#   {% dribbble_set user:ericdfields shots_per_page:10 page:2 %}
#
# All paramaters are optional, e.g.:
#
#   {% dribbble_set shots_per_page:10 page:3 %}
#
# Default Configuration (override in _config.yml):
#
#   dribbble_set:
#     user:            'ericdfields'
#     shots_per_page:  15
#     page:            1
#     gallery_tag:     'ol'
#     gallery_class:   'dribbble_gallery'
#     is_list:         true
#     a_target:        '_blank'
#     full_size:       false
#
# By default, teaser images are linked to their corresponding Dribbble page
# and rendered in an ordered list.
#
# You can disable rendering by setting `is_list` to `false` in your 
# _config.yml. You should probably specify a different `gallery_tag` in this 
# case.
#
# You can also render full_size images instead of the teasers by passing   
# setting `full_size` to `true`
#
# Author: Eric D. Fields
# Site: http://ericdfields.com
# Twitter: @ericdfields
# Email: ericdfields.com
# Plugin Source: http://github.com/ericdfields/jekyll_dribbble_set_tag
# Plugin License: MIT
#
# Thanks to Thomas Mango's Flickr plugin for the inspiration:
# Plugin Source: http://github.com/tsmango/jekyll_flickr_set_tag
# Plugin License: MIT

require 'net/http'
require 'uri'
require 'json'

module Jekyll
  class DribbbleSetTag < Liquid::Tag
    def initialize(tag_name, config, token)
      super

      @config = Jekyll.configuration({})['dribbble_set'] || {}

      # @user                      = /(?<=user:)\w+/.match(config)[0]
      @user                      ||= @config['user']
      @user                      ||= 'ericdfields'

      # @shots_per_page            = /(?<=shots_per_page:)\w+/.match(config)[0]
      @shots_per_page            ||= @config['shots_per_page']
      @shots_per_page            ||= 15 # max 30

      # @page                      = /(?!page:)\d+(?=\spage)/.match(config)[0]
      @page                      ||= @config['page']
      @page                      ||= 1

      @config['gallery_tag']     ||= 'ol'
      @config['gallery_class']   ||= 'dribbble_gallery'
      @config['is_list']         ||= true
      @config['full_size']       ||= false
      @config['a_target']        ||= '_blank'
      
    end

    def render(context)
      if @config['full_size']
        <<-EOF
        <#{@config['gallery_tag']} class="#{@config['gallery_class']}">
          #{images.collect {|image| render_full_size(image)}.join}
        </#{@config['gallery_tag']}>
        EOF
      else
        <<-EOF
        <#{@config['gallery_tag']} class="#{@config['gallery_class']}">
          #{images.collect {|image| render_teaser(image)}.join}
        </#{@config['gallery_tag']}>
        EOF
      end
    end

    def render_teaser(image)
      if @config['is_list']
        <<-EOF
        <li>
          <a href="#{image.url}" target="#{@config['a_target']}">
            <img src="#{image.image_teaser_url}" data-full-size="#{image.image_url}" />
          </a>
        </li>
        EOF
      else
        <<-EOF
        <a href="#{image.url}" target="#{@config['a_target']}">
          <img src="#{image.image_teaser_url}" data-full-size="#{image.image_url}" />
        </a>
        EOF
      end
    end

    def render_full_size(image)
      if @config['is_list']
        <<-EOF
        <li>
          <a href="#{image.url}" target="#{@config['a_target']}">
            <img src="#{image.image_url}" />
          </a>
        </li>
        EOF
      else
        <<-EOF
        <a href="#{image.url}" target="#{@config['a_target']}">
          <img src="#{image.image_url}" />
        </a>
        EOF
      end
    end

    def images
      @images = JSON.parse(json)['shots'].map { |item|
        DribbbleImage.new(item['title'], item['url'], item['image_url'], item['image_teaser_url'], item['width'], item['height'])
      }
    end

    # Get feed with username
    def json
      url     = 'http://api.dribbble.com/players/' + @user + '/shots?per_page=' + @shots_per_page.to_s + '&page=' + @page.to_s
      resp    = Net::HTTP.get_response(URI.parse(url))
      return  resp.body
    end
  end

  class DribbbleImage

    def initialize(title, url, image_url, image_teaser_url, width, height)
      @title              = title
      @url                = url
      @image_url          = image_url
      @image_teaser_url   = image_teaser_url
      @width              = width
      @height             = height
    end

    def title
      return @title
    end

    def url
      return @url
    end

    def image_url
      return @image_url
    end

    def image_teaser_url
      return @image_teaser_url
    end

    def width
      return @width
    end

    def height
      return @height
    end
  end
end

Liquid::Template.register_tag('dribbble_set', Jekyll::DribbbleSetTag)
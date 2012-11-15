# A Dribbble Plugin for Jekyll

Generates image galleries from player's recent shots with customizable
shots per page and which page of results to render.

IMPORTANT: You must comply with the [Terms of Use of the Dribbble API](http://dribbble.com/api) when using this plugin.

---

## Usage: ##

    {% dribble_set %}

* Two examples below DO NOT WORK for now, but will be fixed in the future. Plugin will only read from CONFIG for now. *

### Example: ###

    {% dribble_set user:ericdfields shots_per_page:10 page:2 %}

### All paramaters are optional, e.g.: ###

    {% dribble_set shots_per_page:10 page:3 %}

--- 

## Default Configuration (override in _config.yml): ##

    dribbble_set:
      user:            'ericdfields'
      shots_per_page:  15
      page:            1
      gallery_tag:     'ol'
      gallery_class:   'dribbble_gallery'
      is_list:         true
      a_target:        '_blank'
      full_size:       false

By default, teaser images are linked to their corresponding Dribbble page
and rendered in an ordered list.

You can disable rendering by setting `is_list` to `false` in your 
_config.yml. You should probably specify a different `gallery_tag` in this 
case.

You can also render full_size images instead of the teasers by passing   
setting `full_size` to `true`

---

## Future Enhancements ##

Pretty much anything worthwhile we can get out of http://dribbble.com/api

---

Author: Eric D. Fields &bull; http://ericdfields.com &bull; [@ericdfields](http://twitter.com/ericdfields)

* Plugin Source: http://github.com/ericdfields/Jekyll-Dribbble-Set-Tag
* Plugin License: MIT

Thanks to Thomas Mango's Flickr plugin for the inspiration:

* Plugin Source: http://github.com/tsmango/jekyll_flickr_set_tag
* Plugin License: MIT
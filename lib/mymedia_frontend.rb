#!/usr/bin/env ruby

# file: mymedia_frontend.rb

require 'weblet'


module MyMediaFrontend

  class BrowseView

    def initialize(mediatype='wiki', weblet='', base_url='', css_url='',
                   title=mediatype.capitalize, debug: false)

      @mediatype, @weblet, @base_url = mediatype, weblet, base_url
      @title, @css_url, @debug = title, css_url, debug

    end

    def render()
      nav = @weblet.render 'nav', binding
      @weblet.render('browse', binding)
    end

  end

  class CreateView
  end

  class SearchView
  end

  # partial see wiki.rsf#alphabrowse
  #
  class AlphaBrowse
  end

  # partial see wiki.rsf#initialize
  #
  class Submenu
  end

  class CssView

    def initialize(weblet)

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def browse_css()

      lines = []
      lines << @w.render(:browse)
      lines.join("\n")

    end

  end

  class Main

    def initialize(mediatype='wiki', base_url: '', weblet_html: '',
                   weblet_css: '', css_url: '', debug: false)

      #weblet_file ||= File.join(File.dirname(__FILE__), '..',
      #                          'data', 'mymedia_frontend.txt')
      weblet = weblet_html.is_a?(Weblet) ? weblet_html : \
          Weblet.new(weblet_html)

      @browseview = BrowseView.new(mediatype, weblet, base_url, css_url,
                                   debug: debug)

      #weblet_cssfile ||= File.join(File.dirname(__FILE__), '..',
      #                          'data', 'css.txt')
      @css = CssView.new(weblet_css)

    end

    def browse()
      @browseview.render
    end

    def browse_css()
      @css.browse_css()
    end

  end
end

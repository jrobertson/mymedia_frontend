#!/usr/bin/env ruby

# file: mymedia_frontend.rb

require 'weblet'


module MyMediaFrontend

  class BrowseView

    def initialize(mediatype='wiki', weblet='', css_url='',
                   title=mediatype.capitalize, debug: false)

      @mediatype, @weblet, @css_url, @title = mediatype, weblet, css_url, title
      @debug = debug

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

    def initialize(weblet_file)

      @weblet_file = weblet_file

    end

    def browse_css()

      w = Weblet.new(@weblet_file)

      lines = []
      lines << w.render(:browse)
      lines.join("\n")

    end

  end

  class Main

    def initialize(mediatype='wiki', weblet_file: nil, weblet_cssfile: nil,
                   css_url: '', debug: false)

      weblet_file ||= File.join(File.dirname(__FILE__), '..',
                                'data', 'mymedia_frontend.txt')

      weblet = Weblet.new(weblet_file, css_url)

      @browseview = BrowseView.new(mediatype, weblet, debug: debug)

      weblet_cssfile ||= File.join(File.dirname(__FILE__), '..',
                                'data', 'css.txt')
      @css = CssView.new(weblet_cssfile)

    end

    def browse()
      @browseview.render
    end

    def notice_css()
      @css.browse_css()
    end

  end
end

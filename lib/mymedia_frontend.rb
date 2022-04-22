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

    def initialize(mediatype='wiki', weblet, debug: false)

      @mediatype, @debug = mediatype, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render(a)

      a.map do |x|

        edit_file = File.basename(x.url).sub(/\.html$/,'.txt')
        title = x.title
        title_file = File.basename(x.url).sub(/\.html$/,'')
        id = x.id

        @w.render('alphabrowse', binding)

      end.join("\n")

    end

  end

  class ArticleView

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render(edit_file, article)

      @w.render('articleview', binding)

    end

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

  class EditArticle

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render(content)
      @w.render(:edit_article, binding)
    end

  end

  class Main

    def initialize(mediatype='wiki', base_url: '', weblet_html: '',
                   weblet_css: '', css_url: '', mymedia: nil,
                   title: mediatype.capitalize, debug: false)

      @debug = debug

      weblet_file ||= File.join(File.dirname(__FILE__), '..',
                                'data', 'mymedia_frontend.txt')
      weblet = weblet_html.is_a?(Weblet) ? weblet_html : \
          Weblet.new(weblet_html)

      puts 'before AlphaBrowse' if @debug
      @alphabrowse = AlphaBrowse.new(mediatype, weblet, debug: debug)
      puts 'before ArticleView' if @debug
      @articleview = ArticleView.new(mediatype, weblet, title, debug: debug)
      puts 'before BrowseView' if @debug
      @browseview = BrowseView.new(mediatype, weblet, base_url, css_url,
                                   debug: debug)

      weblet_cssfile ||= File.join(File.dirname(__FILE__), '..',
                                'data', 'css.txt')
      puts 'before CssView' if @debug
      @css = CssView.new(weblet_css)
      puts 'before EditArticle' if @debug
      @edit_article = EditArticle.new(mediatype, weblet, title, debug: debug)

      @mymedia = mymedia

    end

    def alphabrowse(q=nil)
      @alphabrowse.render(@mymedia.browse(q))
    end

    def article_view(htmlfile)

      edit_file = htmlfile.sub(/\.html$/,'.txt')
      doc = Rexle.new(@mymedia.view(htmlfile))
      html = doc.root.element('body/div/article').xml

      @articleview.render(edit_file, html)

    end

    def browse()
      @browseview.render
    end

    def browse_css()
      @css.browse_css()
    end

    def edit_article(filename)
      @edit_article.render(@mymedia.read(filename))
    end

  end
end

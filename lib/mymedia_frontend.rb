#!/usr/bin/env ruby

# file: mymedia_frontend.rb

require 'weblet'
require 'martile'


module MyMediaFrontend

  # classes include:
  #
  #  * AlphaBrowse - browse by alphabet letter
  #  * ArticleView - renders an article page
  #  * BrowseView  - main view
  #  * CreateView  - page to create a new article


  # partial see wiki.rsf#alphabrowse
  #
  class AlphaBrowse

    def initialize(mediatype='wiki', weblet, debug: false)

      @mediatype, @debug = mediatype, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render(a)

      a.map do |x|

        if @mediatype == 'wiki' then
          title_file = File.basename(x.url).sub(/\.html$/,'')
        else
          title_file = x.url[/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+$/]
        end

        title = x.title
        id = x.id

        @w.render('row_links', binding)

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

  class BrowseAllView

    def initialize(mediatype='wiki', weblet='', title, debug: false)

      @mediatype, @title, @weblet = mediatype, title, weblet
      @debug = debug

    end

    def render(a, pg: '1')

      a2 = a.each_slice(15).to_a


      lines = []
      lines << @weblet.render(:browseall, binding)
      lines << a2[pg.to_i-1].map do |x|


        if @mediatype == 'wiki' then
          title_file = File.basename(x.url).sub(/\.html$/,'')
        else
          title_file = x.url[/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+$/]
          title_file = x.url[/[^\/]+$+/] if title_file.nil?
        end

        title = x.title
        id = x.id

        @weblet.render('row_links', binding)

      end.join("\n")

      if a2.length > 1 then

        lines << '<nav id="pages">'

        lines << (1..a2.length).map do |n|
          "<a href='browseall?pg=%d'>%d</a>" % [n,n]
        end.join('&nbsp;')

        lines << '</nav>'
      end

      lines.join("\n")

    end

  end

  class CreateView

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render()

      @w.render('createview', binding)

    end

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

  class DeleteView

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render_confirm(id)

      @w.render(:delete_confirm, binding)

    end

    def render_deleted(id)

      @w.render(:deleted, binding)

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

  class PublishedView

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render()

      @w.render(:published, binding)

    end

  end

  class SearchView

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render()

      @w.render(:search_input, binding)

    end

  end

  class SearchResultsView

    def initialize(mediatype='wiki', weblet, title, debug: false)

      @mediatype, @title, @debug = mediatype, title, debug

      @w = weblet.is_a?(Weblet) ? weblet : Weblet.new(weblet)

    end

    def render(a)

      lines = []
      lines << @w.render('search_input', binding)

      rows = a.map do |x|

        if @mediatype == 'wiki' then
          title_file = File.basename(x.url).sub(/\.html$/,'')
        else
          title_file = x.url[/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+$/]
        end

        title = x.title
        id = x.id

        @w.render('row_links', binding)

      end.join("\n")

      lines << rows
      lines.join("\n")

    end

  end


  # partial see wiki.rsf#initialize
  #
  class Submenu
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
      @browseallview = BrowseAllView.new(mediatype, weblet, title,
                                         debug: debug)

      @createview = CreateView.new(mediatype, weblet, title, debug: debug)

      weblet_cssfile ||= File.join(File.dirname(__FILE__), '..',
                                'data', 'css.txt')
      puts 'before CssView' if @debug
      @css = CssView.new(weblet_css)

      @deleteview = DeleteView.new(mediatype, weblet, title, debug: debug)

      puts 'before EditArticle' if @debug
      @edit_article = EditArticle.new(mediatype, weblet, title, debug: debug)

      @publishedview = PublishedView.new(mediatype, weblet, title, debug: debug)
      @searchview = SearchView.new(mediatype, weblet, title, debug: debug)
      @searchresultsview = SearchResultsView.new(mediatype, weblet, title,
                                                 debug: debug)

      @mediatype,@mymedia = mediatype, mymedia

    end

    def alphabrowse(q=nil)
      @alphabrowse.render(@mymedia.browse(q))
    end

    def article_view(file, id=nil)


      doc = Rexle.new(@mymedia.view(file))

      edit_file = if @mediatype == 'wiki' then
        file.sub(/\.html$/,'') + '.txt'
      else
        if File.extname(file) == '.html' then
          link = doc.root.element('body/div/div/ul/li/a')
          File.basename(link.attributes[:href])
        else
          #@mymedia.find_sourcefile id
          'foo.txt'
        end
      end

      #return doc
      html = doc.root.element('body/div/article').xml

      @articleview.render(edit_file, html)

    end

    def browse()
      @browseview.render
    end

    def browse_all(pg: '1')
      @browseallview.render(@mymedia.browse, pg: pg)
    end

    def browse_css()
      @css.browse_css()
    end

    def create_view()
      @createview.render
    end

    def delete(id, confirmed: false)

      if confirmed then
        @mymedia.delete id
        @deleteview.method(:render_deleted).call(id)
      else
        @deleteview.method(:render_confirm).call(id)
      end

    end

    def edit_article(filename)
      @edit_article.render(@mymedia.read(filename))
    end

    def publish(content)
      r = @mymedia.writecopy_publish content
      @publishedview.render()
    end

    def preview(s)
      Martile.new(s, debug: false).to_html
    end

    def search_view()
      @searchview.render()
    end

    def searchresults_view(keyword)
      @searchresultsview.render(@mymedia.search(keyword))
    end

  end
end

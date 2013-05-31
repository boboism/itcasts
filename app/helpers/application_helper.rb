module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def markdown(text)
    renderer_options = {
      :hard_wrap => true, 
      :gh_blockcode => true, 
      :filter_html => false, 
      :safe_links_only => true
    }
    redcarpet_options = {   
      :space_after_headers => true,
      :fenced_code_blocks => true, 
      :autolink => true, 
      :no_intra_emphasis => true,
      :strikethrough => true, 
      :superscripts => true
    }
    #renderer = PygmentsRenderer.new(renderer_options)
    renderer = CodeRayRenderer.new(renderer_options)
    #renderer = Redcarpet::Render::HTML.new(renderer_options)
    #renderer = AlbinoRenderer.new(renderer_options)

    markdown = Redcarpet::Markdown.new(renderer,redcarpet_options)
    markdown.render(text).html_safe
    #Maruku.new(text).to_html.html_safe
    #RDiscount.new(text).to_html.html_safe
    #GitHub::Markdown.render_gfm(text).html_safe
  end

  class AlbinoRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      Albino.colorize(code, language) 
    end
  end
  
  class CodeRayRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      html = CodeRay.scan(code, language).div#(:tab_width=>2)
      html.gsub!("\n</pre>", "</pre>")
      html
    end
  end

  class PygmentsRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, :lexer => language)
    end
  end
  
end

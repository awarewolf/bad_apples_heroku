module ApplicationHelper

  def navlink(title,model)
    options = {}

    active = is_active?(url_for(model))

    if active
      options[:class] = "active"
      title += '<span class="sr-only">(current)</span>'
    end

    content_tag(:li, options){ link_to(title.html_safe, url_for(model)) }
  end

  private

  def is_active?(url)
    request.path.starts_with? url
  end

  def paginate objects, options = {}
    options.reverse_merge!( theme: 'twitter-bootstrap-3' )

    super( objects, options )
  end

end

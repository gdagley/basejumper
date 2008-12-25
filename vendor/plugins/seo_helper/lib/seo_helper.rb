# SeoHelper
module SeoHelper
  def html_title(site_name, separator = ':')
    title = @content_for_html_page_title 
    content_tag(:title, (title ? "#{title} #{separator} #{site_name}" : site_name))
  end

  def page_title(title, heading_tag = :h1)
    @content_for_html_page_title = title
    content_tag heading_tag, title
  end

  def meta_tags(meta = {})
    return if meta.blank?
    meta.inject("") do |tags, pair|
      tags << tag(:meta, :name => pair.first, :content => pair.last)
    end
  end

  def breadcrumb_trail(crumbs = [], wrapper = :div, delimiter = '>')
    return if crumbs.blank?

    trail = crumbs.inject("") do |trail, crumb|
      trail << " #{h(delimiter)} " unless trail.blank?
      if crumb[:link]
        trail << link_to(h(crumb[:name]), crumb[:link])
      else
        trail << crumb[:name]
      end
    end
    
    content_tag wrapper, trail, :class => 'breadcrumbs'
  end
end

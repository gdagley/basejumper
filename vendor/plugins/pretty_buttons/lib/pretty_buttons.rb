# PrettyButtons
module PrettyButtons
  def pretty_button(label, options = {})
    image = image_tag(options[:icon_path]) if options[:icon_path]
    type  = options[:type]
    content_tag(:button, "#{image} #{label}", {:type => 'submit', :class => "button #{type}"})
  end

  def pretty_positive_button(label, options = {})
    options[:icon_path] ||= 'icons/tick.gif' 
    options[:type] = :positive
    pretty_button(label, options)
  end
  
  def pretty_negative_button(label, options = {})
    options[:icon_path] ||= 'icons/cross.gif' 
    options[:type] = :negative
    pretty_button(label, options)
  end
    
  def pretty_button_link(name, options = {}, html_options = {})
    type = html_options.delete(:type)
    icon_path = html_options.delete(:icon_path)
    image = image_tag(icon_path) if icon_path
    link_to "#{image} #{name}", options, html_options.merge(:class => "button #{type}")
  end

  def pretty_positive_button_link(name, options = {}, html_options = {})
    html_options[:icon_path] ||= 'icons/tick.gif'
    html_options[:type] = :positive
    pretty_button_link(name, options, html_options)
  end
  
  def pretty_negative_button_link(name, options = {}, html_options = {})
    html_options[:icon_path] ||= 'icons/cross.gif'
    html_options[:type] = :negative
    pretty_button_link(name, options, html_options)
  end
end
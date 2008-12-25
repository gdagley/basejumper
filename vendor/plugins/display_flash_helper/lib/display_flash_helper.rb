module DisplayFlashHelper
  def display_flash
    flash_types = [:error, :warning, :notice, :success]

    messages = ((flash_types & flash.keys).collect do |key|
      content_tag(:div, flash[key], :class => "#{key}")
    end.join("\n"))
    
    if messages.size > 0
      content_tag(:div, messages, :id => "flash")
    else
      ""
    end
  end
end
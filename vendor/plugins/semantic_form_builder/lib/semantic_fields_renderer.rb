module SemanticFormBuilder
  class FieldsRenderer
    def initialize(template)
      @super = template
    end
    
    # ===============================================================
    # FORM FIELD HELPERS
    # ===============================================================
    
    #
    # Check in "private helpers" lower in this file to see the definitions for:
    #
    #    - text_field_tag
    #    - password_field_tag 
    #    - text_area_tag
    #
    # These were created dynamically in the method "self.create_field_element"
    #
    
    # creates a file field tag which allows users to select a file
    # this will wrap the file field tag within a definition list 
    # in order to match the sematic style
    #
    # ex:
    #     f.file_field_tag :image, :label => 'Image'
    #
    #  <dt><label for="someid">Name</label></dt>
    #  <dd><input type = 'file'>...</></dd>
    #
    def file_field_tag(name, options = {}) 
      html = content_tag(:dt) do
        content_tag(:label , "#{options.delete(:label)}:", :for => options[:id])
      end
      
      html << content_tag(:dd) do
        @super.file_field_tag(name, options)
      end
    end
    
    # creates a check box tag which allows a boolean value to be toggled
    # this will wrap the check box tag within a definition list
    # in order to match the sematic style
    def check_box_tag(name, options = {})
      html = content_tag(:dt) do
        content_tag(:label , "#{options.delete(:label)}:", :for => options[:id])
      end

      html << content_tag(:dd) do
        checked = options.delete(:value).to_s != 'false'
        @super.check_box_tag(name, "1", checked, options) +
        @super.hidden_field_tag(name, "0")
      end
    end

    # creates a select tag that is generated within a definition item
    # for use within a definition form that has definition items for each field
    #
    #  option_values = options_for_select( [ 'foo', 'bar', 'other' ] )
    #
    #   <dt><label for="someid">Group</label></dt>
    #   <dd><select id="someid">...</select></dd> 
    #
    # ex: f.select_tag(:attribute, @option_values, :label => "example")
    #
    def select_tag(name, option_values, options={})
      label = options.delete(:label) || name.titleize
      label.gsub!(' ', '&nbsp;')
      content_tag("dt", content_tag("label" , "#{label}:", :for => name )) +  "\n" +
      content_tag("dd", @super.select_tag(name, option_values, options))
    end
    
    # places a submit_button in a standardized format with a definition item for a standard form.
    #
    #   <dd class="button"><input id="someid" type ='submit' /></dd>
    #
    # ex: f.submit_tag "Caption"
    #
    def submit_tag(label, options={})
      content_tag(:dd, :class => 'button') do
        @super.submit_tag(label, options)
      end
    end
    
    # places a image_submit_button in a standardized format with a definition item for a standard form.
    #
    #   <dd class="button"><input id="someid" type ='submit' /></dd>
    #
    # ex: f.image_submit_tag 'some_image.png'
    #    
    def image_submit_tag(image_file, options={})
      content_tag(:dd, :class => 'button') do
        @super.image_submit_tag(image_file, options)
      end
    end    
    
    
    # ===============================================================
    # PRIVATE HELPERS
    # ===============================================================
    
    protected
    
    # places a xxxx_tag within the semantic defintion list formatting
    #
    #   <dt><label for="someid">Login</label></dt>
    #   <dd><input id="someid" ... /></dd>
    #
    # ex. f.text_field_tag :login, :label => "Login"
    # 
    # options hash can have { :id => "field id", :label => "field label", :value => "field value", :error => true ]
    #
    def self.create_field_element(input_type)
      field_tag_name = "#{input_type}_tag" # i.e text_field_tag
      
      define_method(field_tag_name) do |name, *args| # defines a method called 'semantic_text_field_tag' 
        field_helper_method = method(field_tag_name.intern)
        options = field_tag_item_options(name, args[0]) # grab the options hash
        
        html = content_tag(:dt) do
          content_tag(:label , "#{options.delete(:label)}:", :for => options[:id])
        end
        
        html << content_tag(:dd) do
          html_tag = @super.send(field_tag_name, name, options.delete(:value).to_s, options)
          options.delete(:error) ? ActionView::Base.field_error_proc.call(html_tag, @object) : html_tag
        end
      end
    end
    
    # for text, password, and check_boxes invoke the 'create_field_element' method to create
    # appropriate helper methods for this renderer for each listed field type
    #
    [ 'text_field', 'password_field', 'text_area' ].each { |field| self.create_field_element(field) }
    
    # given the element_name for the field and the options_hash will construct a hash
    # filled with all pertinent information for creating a field_tag with the correct details
    #
    # used by 'create_field_element' to retrieve the necessary field options for the field element
    #
    # element_name is simply a string or symbol representing the name of the field element such as "user[login]"
    # options_hash can have [ :id, :label, :value ]
    #
    # returns => { :value => 'field_value', :label => "some string", :id => 'some_id', ... }
    # 
    def field_tag_item_options(element_name, options)
      result_options = (options || {}).dup
      result_options[:id] ||= element_name
      result_options[:label]  ||= element_name.to_s.titleize
      result_options[:value]  ||= nil
      result_options
    end
    
    def method_missing(*args, &block)
      @super.send(*args, &block)
    end
  end
end
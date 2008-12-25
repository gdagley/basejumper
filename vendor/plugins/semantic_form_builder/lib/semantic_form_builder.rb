=begin

  This class is a standardized form builder which works to create semantically correct forms, 
  each field with the appropriate label and wrapped within a definition list item in order to 
  represent a list of items using proper xhtml markup.

  The tags allowed are as follows:

  * fieldset(name:string, &block) - wraps the rest of the form items in a definition list
  * text_field      (attribute:symbol, options_hash:hash)
  * password_field  (attribute:symbol, options_hash:hash)
  * file_field      (attribute:symbol, options_hash:hash)
  * text_area       (attribute:symbol, options_hash:hash)
  * check_box       (attribute:symbol, options_hash:hash)
  * radio_buttons   (attribute:symbol, options_hash:hash)
  * submit_button   (label:string)   - create a submit button in a definition item
  * image_submit_button (src:string) - create an image submit button in a definition item

  This form builder is rather easy to use as the example illustrates:

  - semantic_form_for :user, :url => users_path do |f|
    - f.fieldset 'Register' do
      = f.text_field      :login,                 :label => 'Login'
      = f.text_field      :email,                 :label => 'Email'
      = f.password_field  :password,              :label => 'Password'
      = f.password_field  :password_confirmation, :label => 'Password Confirmation'
      = f.submit_button   'Sign up'  

  which generates the following semantically valid markup:
  
  <form method="post" action="/users">
    <fieldset>
      <legend>Register</legend>
      <dl class = "semantic-form">
        <dt><label for="user_login">Login:</label></dt>
        <dd><input type="text" size="30" name="user[login]" id="user_login"/></dd>
  
        <dt><label for="user_email">Email:</label></dt>
        <dd><input type="text" size="30" name="user[email]" id="user_email"/></dd>
  
        <dt><label for="user_password">Password:</label></dt>
        <dd><input type="password" size="30" name="user[password]" id="user_password"/></dd>
  
        <dt><label for="user_password_confirmation">Password Confirmation:</label></dt>
        <dd><input type="password" size="30" name="user[password_confirmation]" id="user_password_confirmation"/></dd>
  
        <dd class="button"><input type="submit" value="Sign up" name="commit"/></dd>
      </dl>
    </fieldset> 
  </form>

=end

module SemanticFormBuilder
  class SemanticBuilder < ActionView::Helpers::FormBuilder  
    
    # Creates a fieldset around the content block as well as wrapping
    # the fields within a definition item and providing an optional legend
    #
    #  <fieldset>
    #     <legend>Some Context</legend>
    #     <dl>
    #         ...block... 
    #     <dl>
    #   </fieldset>
    #
    # ex. 
    #
    #    f.fieldset "Label" do
    #      ...input_fields...
    #    end
    #
    def fieldset(name=nil, &block)
      @renderer = FieldsRenderer.new(@template) # stores the renderer for later use
      @template.semantic_fieldset_tag(name, &block)
    end 
    
    # submit element tag for form within a definition item
    #
    #  <dd class="button">
    #    <input class="button" type="submit" value="Submit"/>
    #  </dd>
    #
    # ex. 
    #     f.submit_button 'Label'
    #
    def submit_button(label, options={})
      @renderer.submit_tag(label, options)
    end
    
    # image submit element tag for form within a definition item
    #
    #  <dd class="button">
    #    <input class="button" type="submit" value="Submit"/>
    #  </dd>
    #
    # ex. 
    #     f.submit_button 'some_image.png'
    #
    def image_submit_button(image_file, options={})
      @renderer.image_submit_tag(image_file, options)
    end
    
    # options => :choices [Array]
    # constructs a group of radio buttons based on the choices given within a definition item
    #
    # <dt>Gender:</dt>
    # <dd>
    #  <input id="user_gender_male" type="radio" value="male" name="user[gender]" checked="checked"/>
    #  <label for="user_gender_male">Male</label>
    #  <input id="user_gender_female" type="radio" value="female" name="user[gender]"/>
    #  <label for="user_gender_female">Female</label>
    # </dd>
    #
    # ex: 
    #     f.radio_buttons :gender, :choices => [ :male, :female ]
    #
    def radio_buttons(attribute, options)
      caption =  (options.delete(:label) || attribute.to_s.titleize).gsub(' ', '&nbsp;') + ":"
      html = @template.content_tag(:dt, caption)
      html << @template.content_tag(:dd) do
        returning choices_html = String.new do
          options[:choices].each do |choice|
            choices_html << radio_button(attribute, choice.to_s) + 
            @template.content_tag("label" , "#{choice.to_s.titleize}", :for => "#{object_name}_#{attribute}_#{choice.to_s}" ) 
          end
        end
      end
    end
    
    # creates a calendar date select object using the "calendar_date_select" plugin
    # this was added in order to wrap the control with the proper definition item
    # as well as add an automatic label when this is added to the view
    #
    # attribute => the field of the record that will be binded to this
    # options => { :label => "some text" } && any of the calendar_date_select options which can be found here:
    #
    #    http://code.google.com/p/calendardateselect/
    #    http://code.google.com/p/calendardateselect/wiki/CalendarDateSelectParameters 
    #
    # ex: 
    #     f.date_select :start_time, :label => "Start", :time => true 
    #
    def date_select(attribute, options={})
      caption = (options.delete(:label) || attribute.to_s.humanize).gsub(' ', '&nbsp;')
      options.reverse_merge!(:valid_date_check => "date >= (new Date()).stripTime()")
      html = @template.content_tag("dt", @template.content_tag("label" , "#{caption}:", :for => "#{object_name}_#{attribute}" )) 
      html << @template.content_tag("dd", calendar_date_select(attribute, options))
    end
    
    # constructs a date selector specifically for birthdays. The day, month, year fields are the attributes 
    # for the user mapping to those individual values
    #
    # options => :day (String), :month (String), :year (String), :start_year (Integer), :include_blank (Boolean)
    #
    # ex: 
    #     f.simple_date_select "Birthday", :month => 'birth_month', :day => 'birth_day', :year => 'birth_year'
    #
    # <dt>Birthday:</dd>
    # <dd>
    #     <select name="user[birth_month]" id="user_birth_month">
    #       <option value=""/>
    #       <option value="1">January</option>
    #       <option value="2">February</option>
    #       <option selected="selected" value="3">March</option>
    #     </select>
    #     <select name="user[birth_day]" id="user_birth_day">
    #       <option value=""/>
    #       <option value="1">1</option>
    #       <option value="2">2</option>
    #     </select>
    #     <select name="user[birth_year]" id="user_birth_year">
    #       <option value=""/>
    #       <option value="1920">1920</option>
    #       <option value="1921">1921</option>
    #     </select>
    #   </dd>
    #
    #
    def simple_date_select(caption, options)
      month_value, day_value, year_value = object.send(options[:month]), object.send(options[:day]), object.send(options[:year])
      end_year = Time.now.year - 10
      html =  @template.content_tag("dt", "#{caption}:")
      html << @template.content_tag("dd") do
        @template.select_month(month_value, :field_name => options[:month], :prefix => object_name.to_s, :include_blank => options[:include_blank]) + "\n" +
        @template.select_day(day_value,   :field_name => options[:day], :prefix => object_name.to_s, :include_blank => options[:include_blank]) + "\n" +
        @template.select_year(year_value,   :field_name => options[:year], :prefix => object_name.to_s, :start_year => end_year, :end_year => options[:start_year], :include_blank => options[:include_blank])
      end
    end
    
    private 
    
    # options include :label which controls the wording of the label
    # given an 'input_type_name' (i.e text_field), defines an additional helper method
    # called 'text_field_element' which prints the form helper in a definition list
    # with the term being the label and the input item being the definition
    #
    # The format of the field element when called should convert to the following html:
    #
    #   <dt><label for="someid">Name</label></dt>
    #   <dd><input id="someid" ... /></dd>
    #
    # ex: self.create_field_element 'text_field' # => overwrites text_field to use definition pair
    #
    def self.create_field_element(input_type_name)
      method_name = input_type_name #i.e method will be defined as 'text_field'
      template_method = "#{input_type_name}_tag" #i.e text_field_tag
      define_method(method_name) do |attribute, *args| # defines a method called 'text_field' 
        raise "Semantic form fields must be contained within a fieldset!" unless @renderer
        options = args.length > 0 ? args[0] : {} # grab the options hash
        object_value = @object ? @object.send(attribute) : nil # grab the object's value
        options.reverse_merge!(:label => attribute.to_s.titleize, :id => "#{object_name(:id)}_#{attribute}", :value => object_value.to_s)
        options.reverse_merge!(:error =>  @object.errors.on(attribute)) if @object
        @renderer.send(template_method, "#{object_name}[#{attribute}]", options)
      end
    end
    
    # creates an element method for each field helper within the form builder
    # allows calls to "any_field_item" which will create that field but wrapped within a definition item
    # ex: text_field_item
    [ 'text_field', 'password_field', 'file_field', 'text_area', 'check_box' ].each do |type_name|
      self.create_field_element(type_name)
    end
    
    # Correctly parses the empty array brackets that can be passed into a form and inserts the id
    #
    # ex: 
    #     semantic_fields_for "social_site[]", social_site_fields do |s|
    #        s.semantic_text_field_tag "login"
    #
    # "social_site[]" means that the object name should be "social_site[#{@object.id}]"
    #
    # returns a string containing the parsed object name if the object name has empty brackets;
    # returns unchanged in any other case.
    #    
    def object_name(id=false)
      return @object_name if @object.nil? or @object.new_record?
      
      replace_string = id ? "_#{@object.id}" : "[#{@object.id}]"
      @object_name.to_s.include?("[]") ? @object_name.gsub(/\[\]/, replace_string) : @object_name
    end
  end
end
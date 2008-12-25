=begin

  This is the essential helper that defines the various standardized form elements
  that will be available for this application. Note that none of the methods
  below actually replace or override any existing field helpers but rather
  add an additional set of "standard" helpers which are items contained within
  a standardized "definition pair" with the label being inside a 'definition term'
  and the actual field within a 'definition data' in order to present a consistent
  and valid markup to the user for all forms.

  Using the field helpers below is easy and note that these same helpers can be accessed
  within model-backed forms by using the 'semantic_form_builder.rb' form builder.

  To use standard forms without a model:

    - form_tag some_url do
      - semantic_fieldset_tag "Name" do |f|
        = f.text_field_tag     :username, :label => "Username"
        = f.password_field_tag :password, :label => "Password"
        = f.check_box_tag      :is_admin, :label => "Administrator?"
        = f.select_tag         :category, @option_values
        = f.submit_tag "Submit"

  To use standard forms with a model:

    - semantic_form_for :user, :url => register_url do |u|
      - u.fieldset do
        = u.text_field     "login"
        = u.password_field "password"
        = u.text_field     "email"
        = u.text_field     "mobile_number", :label => "Mobile No"
        = u.password_field "invite_code", :label => 'Invite'
        = u.submit_button

  To have standard fields within a fields_for a model:

    - semantic_fields_for :user do |u|
      - u.fieldset do 
        = u.text_field     "login"
        = u.password_field "password"

=end

module SemanticFormBuilder
  module Helpers
    
    
    # ===============================================================
    # FORM BLOCK HELPERS
    # ===============================================================
    
    # creates a regular form based on a model's data using the standard builder
    #
    # ex: semantic_form_for(:user, :url => users_path) do # ... end
    #
    def semantic_form_for(name, *args, &block)
      use_semantic_builder(:form_for, name, *args, &block)
    end
    
    # creates a remote form based on a model's data using the standard builder
    #
    # ex: semantic_remote_form_for(:user, :url => users_path) do # ... end
    #
    def semantic_remote_form_for(name, *args, &block)
      use_semantic_builder(:remote_form_for, name, *args, &block)
    end
    
    # creates a fields for based on a model's data using the standard builder
    #
    # ex: semantic_fields_for(:user, :url => users_path) do # ... end
    #
    def semantic_fields_for(name, *args, &block)
      use_semantic_builder(:fields_for, name, *args, &block)
    end
    
    # Creates a fieldset around the content block
    #
    #  <fieldset>
    #     <legend>Some Context</legend>
    #     <dl class="semantic-form">
    #         ...block... 
    #     <dl>
    #   </fieldset>
    #
    # ex. 
    #
    #   semantic_fieldset_tag "Label" do
    #     ...input_fields...
    #   end
    #
    def semantic_fieldset_tag(name=nil, options={}, &block)
      concat(tag(:fieldset, options, true), block.binding)
      concat(content_tag(:legend, name), block.binding) if name
      concat(tag(:dl, { :class => 'semantic-form' }, true), block.binding)
      yield FieldsRenderer.new(self) # yield the field renderer
      concat("</dl>", block.binding)
      concat("</fieldset>", block.binding)
    end  
    
    
    # adds a special option to any form helper block tags such as form_for, fields_for, remote_form_for
    # adds the option specifying that the "StandardBuilder" should be used to build the form
    # this is used when a statement should be made specialized to use this builder
    #
    # ex.
    #
    # def semantic_form_for(name, *args, &block)
    #   use_semantic_builder(:form_for, name, *args, &block)
    # end
    #
    def use_semantic_builder(method_name, name, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options = options.merge(:builder => SemanticFormBuilder::SemanticBuilder)
      args = (args << options)
      method(method_name).call(name, *args, &block)
    end
    
  end
end
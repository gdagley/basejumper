require 'validatable'

class ValidatableForm
  include Validatable

  def self.form_fields(*form_fields)
    return if form_fields.empty?
    attr_accessor *form_fields # !> `*' interpreted as argument prefix
    initializations = form_fields.map { |field| "@#{field} = params[:#{field}]"}.join("\n")
    module_eval "def initialize(params={})\n #{initializations}\n end"
  end
  
  # used by some of the Rails view helpers like form_for
  def id
    nil
  end
  
  # used by some of the Rails view helpers like form_for
  def new_record?
    true
  end
end
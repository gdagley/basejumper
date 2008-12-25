require 'semantic_fields_renderer'
require 'semantic_form_builder'
require 'semantic_form_helpers'
ActionView::Base.send :include, SemanticFormBuilder::Helpers

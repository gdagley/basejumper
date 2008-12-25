require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class BasicTest < Test::Unit::TestCase
  def test_class_loads
    assert_nothing_raised { ActiveForm }
  end
  
  def test_mass_assignments
    self.class.class_eval %q{
      class ContactTest < ActiveForm
        attr_accessor :name, :phone, :email, :subject
        validates_presence_of :name, :phone, :email, :subject
        validates_length_of :name, :phone, :subject, :minimum => 3
        validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      end
    }
    
    params = {
      :name => "Christoph",
      :phone => "123123123",
      :email => "c.schiessl@gmx.net",
      :subject => "Test",
      :not_defined => "Attribute without accessor!"
    }
    
    assert_nothing_raised do
      ct = ContactTest.new(params)
      assert_valid ct
    end
  end
  
  def test_save_and_create_methods
    assert_nothing_raised do
      self.class.class_eval %q{
        class SaveAndCreateTest < ActiveForm
          attr_accessor :name
          validates_presence_of :name
        end
      }
    end
    
    sact = SaveAndCreateTest.new :name => "Christoph"
    assert_nothing_raised(NotImplementedError) { assert sact.save }
    assert_raise(NotImplementedError) { sact.save! }
    assert_raise(NotImplementedError) { sact.update_attribute :name, "Chris" }
    assert_raise(NotImplementedError) { sact.update_attributes :name => "Chris" }
    assert_raise(NotImplementedError) { SaveAndCreateTest.create :name => "Christoph" }
    assert_raise(NotImplementedError) { SaveAndCreateTest.create! :name => "Christoph" }
  end
  
  def test_error_messages
    assert_nothing_raised do
      self.class.class_eval %q{
        class ErrorMessagesTest < ActiveForm
          attr_accessor :email
          validates_presence_of :email, :message => 'is missing'
        end
      }
    end
    
    emt = ErrorMessagesTest.new
    assert_invalid(emt)
    assert_equal "is missing", emt.errors[:email]
    assert_equal "Email is missing", emt.errors.full_messages.first
  end
  
  def test_attributes
    assert_nothing_raised do
      self.class.class_eval %q{
        class AttributesTest < ActiveForm
        end
      }
    end
    
    at = AttributesTest.new
    assert_raise(NoMethodError) { at.not_defined = "test" }
    assert_nothing_raised { at[:not_defined] = "test" }
    assert_equal "test", at[:not_defined]
    assert_equal at[:not_defined], at["not_defined"]
  end
  
  def test_validates_confirmation_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class ConfirmationOfTest < ActiveForm
          attr_accessor :email, :email_confirmation
          validates_confirmation_of :email
        end
      }
    end
    
    cot = ConfirmationOfTest.new
    assert_valid cot
    cot.email_confirmation = cot.email = "someone@example.com"
    assert_valid cot
    cot.email_confirmation = "wrong@address.com"
    assert_invalid cot, "Should be invalid now!"
    assert_not_nil cot.errors.on(:email)
  end
  
  def test_validates_acceptance_of
    assert_raise(NotImplementedError) do
      self.class.class_eval %q{
        class AcceptanceOfTest < ActiveForm
          attr_accessor :terms_of_service
          validates_acceptance_of :terms_of_service
        end
      }
    end
  end
  
  def test_presence_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class PresenceOfTest < ActiveForm
          attr_accessor :email
          validates_presence_of :email
        end
      }
    end
    
    pot = PresenceOfTest.new
    assert_invalid pot
    pot.email = "someone@example.com"
    assert_valid pot
  end
  
  def test_validates_length_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class LengthOfTest < ActiveForm
          attr_accessor :name
          validates_length_of :name, :minimum => 3
        end
      }
    end
    
    lot = LengthOfTest.new
    assert_invalid lot
    lot.name = "Christoph"
    assert_valid lot
  end
  
  def test_validates_uniqueness_of
    assert_raise(NotImplementedError) do
      self.class.class_eval %q{
        class UniquenessTest < ActiveForm
          attr_accessor :email
          validates_uniqueness_of :email
        end
      }
    end
  end
  
  def test_validates_format_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class FormatOfTest < ActiveForm
          attr_accessor :email
          validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
        end
      }
    end
    
    fot = FormatOfTest.new
    assert_invalid fot
    fot.email = "abc"
    assert_invalid fot
    fot.email = "c.schiessl@gmx.net"
    assert_valid fot
  end
  
  def test_validates_inclusion_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class InclusionOfTest < ActiveForm
          attr_accessor :booltest, :texttest
          validates_inclusion_of :booltest, :in => [true, false]
          validates_inclusion_of :texttest, :in => %w{Joe Mike Jack}
        end
      }
    end
    
    iot = InclusionOfTest.new
    assert_invalid iot
    iot.booltest, iot.texttest = true, "Jack"
    assert_valid iot
  end
  
  def test_validates_exclusion_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class ExclusionOfTest < ActiveForm
          attr_accessor :name
          validates_exclusion_of :name, :in => %w{Bill Gates}
        end
      }
    end
    
    eot = ExclusionOfTest.new
    assert_valid eot
    eot.name = "Bill"
    assert_invalid eot
    eot.name = "Christoph"
    assert_valid eot
  end
  
  def test_validates_associated
    assert_raise(NotImplementedError) do
      self.class.class_eval %q{
        class AssociatedTest < ActiveForm
          attr_accessor :test
          validates_associated :test
        end
      }
    end
  end
  
  def test_validates_numericality_of
    assert_nothing_raised do
      self.class.class_eval %q{
        class NumericalityTest < ActiveForm
          attr_accessor :width, :height
          validates_numericality_of :width, :height
        end
      }
    end
    
    nt = NumericalityTest.new
    assert_invalid nt
    nt.width, nt.height = 123, "123"
    assert_valid nt
    nt.width = "123sdf"
    assert_invalid nt
    assert_not_nil nt.errors[:width]
  end
  
  def test_validates_on_create
    assert_raise(NotImplementedError) do
      self.class.class_eval %q{
        class OnCreateTest < ActiveForm
          attr_accessor :name
          validates_on_create do
            # do something
          end
        end
      }
    end
  end
  
  def test_validates_on_update
    assert_raise(NotImplementedError) do
      self.class.class_eval %q{
        class OnUpdateTest < ActiveForm
          attr_accessor :name
          validates_on_update do
            # do something
          end
        end
      }
    end
  end
end

# see http://github.com/spicycode/beholder/tree/master
map_for(:default_dungeon) do |wizard|
  
  # these are the directories we will be watching
  wizard.keep_a_watchful_eye_for 'app', 'config', 'lib', 'spec'
 
  # changes to files in app directory will run the corresponding spec in the spec directory
  wizard.prepare_spell_for /\/app\/(.*)\.rb/ do |spell_component|
    ["spec/#{spell_component[1]}_spec.rb"]
  end
  
  # changes files in the lib directory will run the corresponding spec in the spec/lib directory
  wizard.prepare_spell_for /\/lib\/(.*)\.rb/ do |spell_component|
    ["spec/lib/#{spell_component[1]}_spec.rb"]
  end
  
  # changes files in the spec directory will re-run the spec
  wizard.prepare_spell_for /\/spec\/(.*)_spec\.rb/ do |spell_component|
    ["spec/#{spell_component[1]}_spec.rb"]
  end
  
  # changes to the spec_helper will re-run all specs
  wizard.prepare_spell_for /\/spec\/spec_helper\.rb/ do |spell_component|
    Dir["spec/**/*_spec.rb"]
  end

  # changes to anything in the config directory will re-run all specs
  wizard.prepare_spell_for /\/config/ do
    Dir["spec/**/*_spec.rb"]
  end
end
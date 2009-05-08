# see http://github.com/spicycode/beholder/tree/master
map_for(:default_dungeon) do |wizard|
  
  # these are the directories we will be watching
  wizard.keep_a_watchful_eye_for 'app', 'config', 'lib', 'examples'
 
  # changes to files in app directory will run the corresponding example in the examples directory
  wizard.prepare_spell_for /\/app\/(.*)\.rb/ do |spell_component|
    ["examples/#{spell_component[1]}_example.rb"]
  end
  
  # changes files in the lib directory will run the corresponding example in the examples/lib directory
  wizard.prepare_spell_for /\/lib\/(.*)\.rb/ do |spell_component|
    ["examples/lib/#{spell_component[1]}_example.rb"]
  end
  
  # changes files in the example directory will re-run the examples
  wizard.prepare_spell_for /\/example\/(.*)_example\.rb/ do |spell_component|
    ["examples/#{spell_component[1]}_example.rb"]
  end
  
  # changes to the example_helper will re-run all examples
  wizard.prepare_spell_for /\/example\/example_helper\.rb/ do |spell_component|
    Dir["examples/**/*_example.rb"]
  end

  # changes to anything in the config directory will re-run all examples
  wizard.prepare_spell_for /\/config/ do
    Dir["examples/**/*_example.rb"]
  end
end
# from http://forrst.com/posts/Rake_task_for_code_analysis_of_Rails_apps-2Iw
begin
  require 'term/ansicolor'

  namespace :analyzer do
    desc "run all code analyzing tools (coverage, rails_best_practices)"
    task :all => ['coverage', 'rails_best_practices'] do
      message(:info, 'have been running all code analyzing tools')
    end

    desc "run rails_best_practices and inform about found issues"
    task :rails_best_practices do
      require 'rails_best_practices'
      message(:info, 'Running rails_best_practices and inform about found issues')
      app_root = Rake.application.original_dir
      output_file = File.join(app_root, 'tmp', 'rails_best_practices.html')
      analyzer = RailsBestPractices::Analyzer.new(app_root, {
        'format' => 'html',
        'with-textmate' => true,
        'output-file' => output_file
      })
      analyzer.analyze
      analyzer.output
      `open #{output_file}`
      # fail "found bad practices" if analyzer.runner.errors.size > 0
    end

    desc "Create rspec coverage"
    task :coverage do
      ENV['COVERAGE'] = 'true'
      Rake::Task["spec"].execute
      app_root = Rake.application.original_dir
      output_file = File.join(app_root, 'coverage', 'index.html')
      `open #{output_file}`
    end
  end

  def message(type, message)
    set_color(type)
    puts message
    reset_color
  end

  def set_color(type)
    term = Term::ANSIColor
    colors = {info: term.green, error: term.red}
    puts colors[type]
  end

  def reset_color
    puts Term::ANSIColor.reset
  end

rescue LoadError => err
  # WE DONT CARE ABOUT THIS ON HEROKU, BUT OUTPUT IS NICE IN DEV
  warn err.message
end

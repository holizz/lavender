begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'lavender'
    gem.summary = %Q{Minimalistic YAML-based CMS}
    gem.email = 'tom@holizz.com'
    gem.homepage = 'http://github.com/holizz/lavender'
    gem.authors = ['Tom Adams']
    gem.add_dependency 'haml'
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'jeweler'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

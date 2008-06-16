require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'


desc 'Default: run unit tests.'
task :default => :spec


desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

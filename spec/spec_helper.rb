require 'rubygems'
require 'spec'
gem 'mocha'

require File.join(File.dirname(__FILE__), 'boot') unless defined?(ActiveRecord)

require 'data_table'
include DataTable

class HaveHtmlLinkWith
  def initialize(expected_options)
    @expected_options = expected_options
  end
  def matches?(target)
    @target = target
    dat_match = Regexp.compile( '<a href="(.+)">', Regexp::MULTILINE)
    match = @target.match dat_match
    return false unless match
    matched_link = match[1]
    all_matched = @expected_options.each.inject(true) do |acc, opt|
      puts "matching #{matched_link} against #{opt[0]}=#{opt[1]}"
      acc = acc && Regexp.compile("#{opt[0]}=#{opt[1]}", Regexp::MULTILINE), matched_link
    end
  end
  def failure_message
    "expected #{@target.inspect} to match all of #{@expected_options}, but did not"
  end
  def negative_failure_message
    "expected #{@target.inspect} not to match all of #{@expected_options}, but did"
  end
end



def have_html_link_with(expected)
  HaveHtmlLinkWith.new(expected)
end





#require File.join(File.dirname(__FILE__), 'mock_controller')
require File.join(File.dirname(__FILE__), 'filter_controller')

# Wrap tests that use Mocha and skip if unavailable.
def uses_mocha(test_name)
  require 'mocha' unless Object.const_defined?(:Mocha)
rescue LoadError => load_error
  $stderr.puts "Skipping #{test_name} tests. `gem install mocha` and try again."
else
  yield
end
require 'test/unit'
require 'rubygems'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

require File.join(File.dirname(__FILE__), 'boot') unless defined?(ActiveRecord)
require File.join(File.dirname(__FILE__), '/../lib/data_table')
include DataTable

class HaveHtmlLinkWith
  def initialize(expected_options)
    @expected_options = expected_options
  end
  def matches?(target)
    @target = target
    dat_match = Regexp.compile( '<a href="(.+)">', Regexp::MULTILINE)
    @match = @target.match dat_match
    return false unless @match
    matched_link = @match[0]
    all_matched = true
    @expected_options.inject(true) do |acc, opt|
      acc && (matched_link =~ Regexp.compile(Regexp.escape("#{opt[0]}=#{opt[1]}"), Regexp::MULTILINE))
    end
  end
  def failure_message
    "expected #{@match[0].inspect} to match all of #{@expected_options.inspect}, but did not"
  end
  def negative_failure_message
    "expected #{@match[0].inspect} not to match all of #{@expected_options.inspect}, but did"
  end
end



def have_html_link_with(expected)
  HaveHtmlLinkWith.new(expected)
end

def regexify(string, options = nil)
  Regexp.compile(Regexp.escape(string), options)
end

# Wrap tests that use Mocha and skip if unavailable.
def uses_mocha(test_name)
  require 'mocha' unless Object.const_defined?(:Mocha)
rescue LoadError => load_error
  $stderr.puts "Skipping #{test_name} tests. `gem install mocha` and try again."
else
  yield
end
$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
gem 'rspec', ">=1.1.0"

%w[weewar].each {|f| require f }

module XmlFixtures
  def load_fixture(name)
    File.open(File.join(File.dirname(__FILE__), %W[fixtures #{name}.xml]))
  end
end
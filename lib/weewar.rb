require 'rubygems'
require 'xmlsimple'
require 'open-uri'

module Weewar
  class << self
    def version
      '0.1'
    end
  end
  
  class Base
    class << self
      attr_accessor :base_url
      def find(id)
        data = open("#{base_url}/#{id}")
        new(data)
      end
      
      def integer_attr(*args)
        args.each do |name|
          define_method(name) do
            @data[name.to_s].to_i
          end
        end
      end
      
      def string_attr(*args)
        args.each do |name|
          define_method(name) do
            @data[name.to_s]
          end
        end
      end
      
      def boolean_attr(*args)
        args.each do |name|
          define_method(name) do
            @data[name.to_s] == 'true'
          end
        end
      end
      
      def time_attr(*args)
        args.each do |name|
          define_method(name) do
            Time.parse(@data[name.to_s])
          end
        end
      end
    end
    
    def initialize(file = nil)
      load(file) if file
    end
  end
end

require 'weewar/user'
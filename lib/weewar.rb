require 'rubygems'
require 'xmlsimple'
require 'open-uri'

require 'weewar/util'

module Weewar
  class << self
    def version
      '0.1'
    end
  end
  
  class Base
    class << self
      attr_accessor :base_url, :xml_options
      def find(id)
        data = open("#{base_url}/#{id}")
        new(data)
      end
      
      def integer_attr(*args)
        args.each do |name|
          define_method(name) do
            @data[name.to_s].to_i
          end
          underscore_alias(name)
        end
      end
      
      def string_attr(*args)
        args.each do |name|
          define_method(name) do
            @data[name.to_s]
          end
          underscore_alias(name)
        end
      end
      
      def boolean_attr(*args)
        args.each do |name|
          define_method(name) do
            @data[name.to_s] == 'true'
          end
          boolean_alias(name)
          underscore_alias(name)
        end
      end
      
      def time_attr(*args)
        args.each do |name|
          define_method(name) do
            Time.parse(@data[name.to_s])
          end
          underscore_alias(name)
        end
      end
      
      def underscore_alias(name)
        name = name.to_sym
        underscored = name.to_s.underscore.to_sym
        unless underscored == name
          alias_method underscored, name
        end
      end
      
      def boolean_alias(name)
        qname = name.to_s + "?"
        alias_method qname.to_sym, name.to_sym
        underscore_alias qname
      end
    end
    
    def initialize(file = nil)
      load(file) if file
    end
    
    def load(file)
      @data = XmlSimple.xml_in(file, self.class.xml_options || {})
    end
    
    def reload
      id = self.id
      instance_variables.each {|ivar| instance_variable_set(ivar, nil) }
      data = open("#{self.class.base_url}/#{id}")
      load(data) if data
    end
    
    def ==(other)
      other.is_a?(self.class) && other.id == self.id
    end
  end
end

require 'weewar/user'
require 'weewar/game'
require 'yaml'
class FileNotFoundError < IOError; end;

module FixToChix

  class FixtureParser

    DEFAULT_NAMES = ["one", "two"]

    attr_reader :output_buffer, :factory_names, :factory_writer

    def initialize(fixture_file)
      raise ArgumentError if fixture_file.nil?
      raise FileNotFoundError unless File.exists?(fixture_file)
      @fixture_file = fixture_file
    end

    def model_name
      @fixture_file.match(/(\w+)\.yml/)
      $1.singularize
    end

    def parse_fixture
      @current_fixture = YAML.load_file(@fixture_file)
      @factory_names = @current_fixture.map{ |key, value| key }
      @output_buffer = define_factories
    end

    def attributes_for(factory_name)
      @current_fixture[factory_name].map {|key, value| key if key != "id" }
    end

    def define_factories
      factory_definition = []
      @factory_names.each do |name|
        factory_definition << "FactoryBot.define do" 
        factory_definition << "  factory :#{self.factory_name(name)}, :class => #{model_name.camelize} do |#{model_name[0].chr}|"
        define_attributes_for(name).each do |attrib|
          factory_definition << attrib
        end
        factory_definition << "  end\nend"
        factory_definition << ""
      end
      factory_definition
    end

    def define_attributes_for(name)
      attributes = attributes_for(name)
      attributes.map {|attr| write_factory_attribute(name, attr) }.reverse
    end

    def write_factory_attribute(name, attribute)
      attr_value = @current_fixture[name][attribute]
      "  #{model_name[0].chr}.#{attribute} { #{type_to_literal(attr_value)} }"
    end

    def type_to_literal(value)
     case value
      when String
        "\"#{value}\""
      when NilClass
        "nil"
      when FalseClass, TrueClass
        "#{value}"
      when BigDecimal
         "BigDecimal.new(\"#{value}\")"
      when Numeric
	"#{value}"
      when Time
        "DateTime.parse(\"#{value}\")"
      else
	raise "#{value.class} : #{value} needs literal conversion"
     end
    end	

    def factory_name(node_name)
      DEFAULT_NAMES.include?(node_name) ? "#{self.model_name}_#{node_name}" : node_name
    end
  end
end

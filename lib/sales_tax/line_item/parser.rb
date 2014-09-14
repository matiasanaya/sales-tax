require_relative 'base'
require_relative 'book'
require_relative 'food'
require_relative 'medicine'

module SalesTax
  module LineItem
    module Parser
      module_function

      FormatError = Class.new(StandardError)

      @input_validator = lambda do |_in|
        raise FormatError unless _in =~ /\A\d+,[^,]*\w+, \d+(.\d)?\d*\z/
      end

      @pre_processor = lambda do |_in|
        quantity_str, description, unit_price_str = _in.split(',')

        {
          quantity: quantity_str.to_i,
          description: description.strip,
          unit_price: unit_price_str.strip
        }
      end

      @matcher = lambda do |_in|
        match = nil
        [LineItem::Book, LineItem::Medicine, LineItem::Food].each do |matcher|
          match = matcher.match(_in)
          break if match
        end
        match ||= LineItem::Base.match(_in)
      end

      def parse(_in)
        @input_validator.call(_in)
        @matcher.call(@pre_processor.call(_in))
      end
    end
  end
end

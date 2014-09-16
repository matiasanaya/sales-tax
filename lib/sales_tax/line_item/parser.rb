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
          quantity: quantity_str,
          description: description.strip,
          unit_price: unit_price_str.strip
        }
      end

      @augmenter = lambda do |_in|
        augmented = nil
        [LineItem::Book, LineItem::Medicine, LineItem::Food].each do |augmenter|
          augmented = augmenter.augment(_in)
          break if augmented
        end
        augmented || LineItem::Base.augment(_in)
      end

      def parse(_in)
        @input_validator.call(_in)
        @augmenter.call(@pre_processor.call(_in))
      end
    end
  end
end

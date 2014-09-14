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
          description: description,
          unit_price: unit_price_str.strip
        }
      end

      def parse(_in)
        @input_validator.call(_in)
        @pre_processor.call(_in)
      end
    end
  end
end

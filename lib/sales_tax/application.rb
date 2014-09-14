require_relative 'line_item/parser'
require_relative 'receipt'

module SalesTax
  class Application
    def initialize(args = {})
      @input = args[:input] || $stdin
      @parser = LineItem::Parser
      @receipt = Receipt.new
    end

    def run
      loop do
        raw_input = input.gets
        break unless raw_input
        raw_input.chomp!
        line_item = parser.parse(raw_input)
        receipt.add_item(line_item) if line_item
      end
      puts receipt.print
    end

    private

    attr_reader :input, :parser, :receipt
  end
end

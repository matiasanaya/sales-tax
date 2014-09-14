require_relative '../accountable'

module SalesTax
  module LineItem
    class Base
      include SalesTax::Accountable

      def initialize(args = {})
        @quantity = args[:quantity]
        @description = args[:description]
        @unit_price_str = args[:unit_price]
      end

      def to_hash
        accountable_to_hash.merge({
          quantity: quantity,
          description: description,
          unit_price: unit_price_str
        })
      end

      private

      attr_reader :quantity, :description, :unit_price_str

      def category
        :other
      end

      def imported?
        description =~ /\simported\s/
      end
    end
  end
end

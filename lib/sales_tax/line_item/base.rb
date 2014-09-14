require_relative '../accountable'

module SalesTax
  module LineItem
    class Base
      include SalesTax::Accountable

      def initialize(args = {})
        @quantity = args[:quantity]
        @description = args[:description]
        @unit_price = args[:unit_price]
      end

      def to_hash
        accountable_to_hash.merge({
          quantity: quantity,
          description: description,
          unit_price: unit_price,
        })
      end

      private

      attr_reader :quantity, :description, :unit_price

      def category
        :other
      end

      def imported?
        description =~ /\simported\s/
      end
    end
  end
end

require_relative '../accountable'

module SalesTax
  module LineItem
    class Base
      include SalesTax::Accountable

      def self.augment(attributes)
        new(attributes).to_hash if attributes[:description] =~ description_matcher
      end

      def initialize(args = {})
        @quantity_str = args[:quantity] || ''
        @description = args[:description]
        @unit_price_str = args[:unit_price] || ''
      end

      def to_hash
        accountable_hash.merge(
          {
            quantity: quantity_str,
            description: description,
            unit_price: unit_price_str
          }
        )
      end

      private

      attr_reader :quantity_str, :description, :unit_price_str

      def self.description_matcher
        /\w+/
      end

      def category
        :other
      end

      def imported?
        /imported/.match(description) ? true : false
      end
    end
  end
end

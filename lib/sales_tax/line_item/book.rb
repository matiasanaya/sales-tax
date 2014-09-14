module SalesTax
  module LineItem
    class Book < Base
      def category
        :book
      end

      private

      def self.description_matcher
        /book/
      end
    end
  end
end

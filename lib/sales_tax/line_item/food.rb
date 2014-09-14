module SalesTax
  module LineItem
    class Food < Base
      def category
        :food
      end

      private

      def self.description_matcher
        /chocolate/
      end
    end
  end
end

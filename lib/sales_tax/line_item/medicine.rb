module SalesTax
  module LineItem
    class Medicine < Base
      def category
        :medicine
      end

      private

      def self.description_matcher
        /headache/
      end
    end
  end
end

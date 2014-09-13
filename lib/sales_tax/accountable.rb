require 'bigdecimal'

module SalesTax
  module Accountable
    def unit_sales_tax
      round_tax(unit_price * sales_tax_rate)
    end

    private

    def round_tax(tax)
      round_factor = BigDecimal('1')/BigDecimal('0.05')
      (tax * round_factor).ceil/round_factor
    end

    def sales_tax_rate
      basic_sales_tax_rate + import_duty_sales_tax_rate
    end

    def import_duty_sales_tax_rate
      imported? ? reference_import_duty_sales_tax_rate : BigDecimal('0')
    end

    def basic_sales_tax_rate
      basic_sales_tax_exempt? ? BigDecimal('0') : reference_basic_sales_tax_rate
    end

    def reference_basic_sales_tax_rate
      BigDecimal('0.1')
    end

    def reference_import_duty_sales_tax_rate
      BigDecimal('0.05')
    end

    def basic_sales_tax_exempt?
      [:food, :medical, :book].include?(category)
    end
  end
end

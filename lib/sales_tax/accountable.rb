require 'bigdecimal'

module SalesTax
  module Accountable
    def to_hash
      accountable_hash
    end

    protected

    def accountable_hash
      {
        unit_sales_tax: unit_sales_tax.to_s('F'),
        total_unit_price: (unit_price + unit_sales_tax).to_s('F')
      }
    end

    private

    def unit_sales_tax
      round_tax(unit_price * sales_tax_rate)
    end

    def unit_price
      BigDecimal(unit_price_str)
    end

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
      [:food, :medicine, :book].include?(category)
    end
  end
end

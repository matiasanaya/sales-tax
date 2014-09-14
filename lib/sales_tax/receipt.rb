module SalesTax
  class Receipt
    def initialize(args = {})
      @items = args[:items] || []
    end

    def add_item(item)
      items << item
    end

    def print
      _print = ""
      total = BigDecimal('0')
      sales_taxes_total = BigDecimal('0')
      items.each do |item|
        total += BigDecimal(item[:total_unit_price])
        sales_taxes_total += BigDecimal(item[:unit_sales_tax])
        _print << print_item(item)
      end
      _print << "\n"
      _print << print_sales_taxes_total(sales_taxes_total)
      _print << print_total(total)
      _print
    end

    private

    attr_accessor :items

    def print_total(bd)
      total = format_to_money_string(bd.to_s('F'))
      "Total: #{total}\n"
    end

    def print_sales_taxes_total(bd)
      total  = format_to_money_string(bd.to_s('F'))
      "Sales Taxes: #{total}\n"
    end

    def print_item(item)
      taxed_price_str = format_to_money_string(item[:total_unit_price])
      "#{item[:quantity]}, #{item[:description]}, #{taxed_price_str}\n"
    end

    def format_to_money_string(str)
      sprintf("%.2f", str)
    end
  end
end

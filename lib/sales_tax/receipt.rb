module SalesTax
  class Receipt
    def initialize(args = {})
      @items = args[:items] || []
    end

    def add_item(item)
      items << item
    end

    def print
      _print = ''
      _print << print_items
      _print << "\n"
      _print << print_totals
      _print
    end

    private

    attr_accessor :items

    def print_items
      _items = ''
      items.each { |i| _items << print_item(i) }
      _items
    end

    def print_item(item)
      taxed_price_str = format_to_money_string(item[:total_unit_price])
      "#{item[:quantity]}, #{item[:description]}, #{taxed_price_str}\n"
    end

    def print_totals
      total, sales_taxes_total = calculate_totals
      _totals = ''
      _totals << print_sales_taxes_total(sales_taxes_total)
      _totals << print_total(total)
      _totals
    end

    def calculate_totals
      total = BigDecimal('0')
      sales_taxes_total = BigDecimal('0')
      items.each do |item|
        total += BigDecimal(item[:total_unit_price])
        sales_taxes_total += BigDecimal(item[:unit_sales_tax])
      end
      [total, sales_taxes_total]
    end

    def print_sales_taxes_total(bd)
      st_total  = format_to_money_string(bd.to_s('F'))
      "Sales Taxes: #{st_total}\n"
    end

    def print_total(bd)
      total = format_to_money_string(bd.to_s('F'))
      "Total: #{total}\n"
    end

    def format_to_money_string(str)
      sprintf("%.2f", str)
    end
  end
end

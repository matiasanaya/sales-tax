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
        h = item.to_hash
        total += h[:total_unit_price]
        sales_taxes_total += h[:unit_sales_tax]
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
      total = format_bd_to_price_string(bd)
      "Total: #{total}\n"
    end

    def print_sales_taxes_total(bd)
      total  = format_bd_to_price_string(bd)
      "Sales Taxes: #{total}\n"
    end

    def print_item(item)
      print_item_from_hash(item.to_hash)
    end

    def print_item_from_hash(hash)
      taxed_price_str = format_bd_to_price_string(hash[:total_unit_price])

      "#{hash[:quantity]}, #{hash[:description]}, #{taxed_price_str}\n"
    end

    def format_bd_to_price_string(bd)
      sprintf("%.2f", bd_to_float_str(bd))
    end

    def bd_to_float_str(bd)
      bd.to_s('F')
    end
  end
end

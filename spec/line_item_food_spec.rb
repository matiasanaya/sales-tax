require_relative '../lib/sales_tax/line_item/food'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Food do
  let(:object_klass) { SalesTax::LineItem::Food }
  let(:category) { :food }
  it_behaves_like 'a line item'
end

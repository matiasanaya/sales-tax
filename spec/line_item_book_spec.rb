require_relative '../lib/sales_tax/line_item/book'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Book do
  let(:object_klass) { SalesTax::LineItem::Book }
  let(:category) { :book }
  it_behaves_like 'a line item'
end

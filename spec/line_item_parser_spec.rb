require_relative '../lib/sales_tax/line_item/parser'

RSpec.describe SalesTax::LineItem::Parser do
  let(:parser) { SalesTax::LineItem::Parser }

  shared_examples 'a correct parser' do |_in, _out|
    it 'does the job' do
      expect(parser.parse(_in)).to eql _out
    end
  end

  shared_examples 'a complaining parser' do |_in|
    it 'screams' do
      expect{ parser.parse(_in) }.to raise_exception SalesTax::LineItem::Parser::FormatError
    end
  end

  context 'when invalid input' do
    context 'with missing arguments' do
      it_behaves_like 'a complaining parser', '1, description'
    end

    context 'with too many arguments' do
      it_behaves_like 'a complaining parser', '1, description, 12.49, 1'
    end

    context 'with arguments in wrong order' do
      it_behaves_like 'a complaining parser', '12.49, description, 1'
    end

    context 'with no description' do
      it_behaves_like 'a complaining parser', '1, , 12.49'
    end
  end

  context 'when valid input' do
    context 'control' do
      line_item = '1, description, 12.49'
      parsed_line_item = {
        quantity: 1,
        description: ' description',
        unit_price: BigDecimal('12.49')
      }

      it_behaves_like 'a correct parser', line_item, parsed_line_item
    end

    context 'with quantity' do
      line_item = '5, description, 0.0'
      parsed_line_item = {
        quantity: 5,
        description: ' description',
        unit_price: BigDecimal('0.0')
      }

      it_behaves_like 'a correct parser', line_item, parsed_line_item
    end

    context 'with description' do
      line_item = '0, a imported description, 0.0'
      parsed_line_item = {
        quantity: 0,
        description: ' a imported description',
        unit_price: BigDecimal('0.0')
      }

      it_behaves_like 'a correct parser', line_item, parsed_line_item
    end

    context 'with unit price' do
      line_item = '0, description, 12.49'
      parsed_line_item = {
        quantity: 0,
        description: ' description',
        unit_price: BigDecimal('12.49')
      }

      it_behaves_like 'a correct parser', line_item, parsed_line_item
    end
  end
end

require_relative '../lib/sales_tax/line_item/parser'

RSpec.describe SalesTax::LineItem::Parser do
  let(:parser) { SalesTax::LineItem::Parser }

  shared_examples 'a correct parser' do |_in, _out|
    it 'does the job' do
      expect(parser.parse(_in)).to include _out
    end
  end

  shared_examples 'a complaining parser' do |_in|
    it 'screams' do
      expect{ parser.parse(_in) }.to raise_exception SalesTax::LineItem::Parser::FormatError
    end
  end

  context 'when cherry picked input' do
    it_behaves_like 'a correct parser',
                    '1, book, 12.49',
                    {
                      quantity: 1,
                      description: 'book',
                      unit_price: '12.49',
                      unit_sales_tax: '0.0',
                      total_unit_price: '12.49'
                    }
  end

  context 'when invalid input' do
    context 'with missing arguments' do
      it_behaves_like 'a complaining parser',
                      '1, description'
    end

    context 'with too many arguments' do
      it_behaves_like 'a complaining parser',
                      '1, description, 12.49, 1'
    end

    context 'with arguments in wrong order' do
      it_behaves_like 'a complaining parser',
                      '12.49, description, 1'
    end

    context 'with no description' do
      it_behaves_like 'a complaining parser',
                      '1, , 12.49'
    end
  end

  context 'when valid input' do
    context 'control' do
      it_behaves_like 'a correct parser',
                      '1, description, 12.49',
                      {
                        quantity: 1,
                        description: 'description',
                        unit_price: '12.49'
                      }
    end
    context 'moar control' do
      it 'it has accountable fields' do
        expect(parser.parse('1, description, 12.49')).to include :unit_sales_tax, :total_unit_price
      end
    end

    context 'with quantity' do
      it_behaves_like 'a correct parser',
                      '5, description, 0.0',
                      {quantity: 5}
    end

    context 'with description' do
      it_behaves_like 'a correct parser',
                      '0, a imported description, 0.0',
                      {description: 'a imported description'}
    end

    context 'with unit price' do
      it_behaves_like 'a correct parser',
                      '0, description, 12.49',
                      {unit_price: '12.49'}
    end
  end
end

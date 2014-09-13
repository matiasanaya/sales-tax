require_relative '../lib/sales_tax/accountable'
require_relative 'shared_examples_for_accountable'
require_relative 'shared_examples_for_taxable'

RSpec.describe SalesTax::Accountable do
  AccountableDouble = Struct.new(:unit_price, :imported?, :category) do
    include SalesTax::Accountable
  end
  let(:accountable_double) {
    AccountableDouble.new(BigDecimal('11.25'), imported?, category)
  }

  describe 'AccountableDouble' do
    let(:object) { AccountableDouble.new(BigDecimal('11.25'), true, :other) }
    it_behaves_like 'a accountable'
    it_behaves_like 'a taxable'
  end
  describe '#unit_sales_tax' do
    subject { accountable_double.unit_sales_tax }

    context 'when basic exempt' do
      ['food', 'medical', 'book'].each do |cat|
        context "when #{cat}" do
          let(:category) { cat.to_sym }

          context 'when local' do
            let(:imported?) { false }
            it { is_expected.to eq BigDecimal('0') }
          end

          context 'when imported' do
            let(:imported?) { true }
            it { is_expected.to eq BigDecimal('0.6') }
          end
        end
      end
    end

    context 'when basic applicable' do
      let(:category) { :other }

      context 'when local' do
        let(:imported?) { false }
        it { is_expected.to eq BigDecimal('1.15') }
      end

      context 'when imported' do
        let(:imported?) { true }
        it { is_expected.to eq BigDecimal('1.7') }
      end
    end
  end
end

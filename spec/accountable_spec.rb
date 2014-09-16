require_relative '../lib/sales_tax/accountable'
require_relative 'shared_examples_for_accountable'
require_relative 'shared_examples_for_taxable'

RSpec.describe SalesTax::Accountable do
  AccountableDouble = Struct.new(:unit_price_str, :imported?, :category) do
    include SalesTax::Accountable
  end

  let(:accountable) {
    AccountableDouble.new('11.25', true, :other)
  }

  describe 'AccountableDouble' do
    let(:object) { accountable }
    it_behaves_like 'a accountable'
    it_behaves_like 'a taxable'
  end

  describe '#to_hash' do
    describe '[:total_unit_price]' do
      subject { accountable.to_hash[:unit_sales_tax] }
      it { is_expected.to eq '1.7'}
    end

    describe '[:unit_sales_tax]'do
      subject {
        AccountableDouble.new('11.25', imported?, category).to_hash[:unit_sales_tax]
      }

      context 'when basic exempt' do
        ['food', 'medicine', 'book'].each do |cat|
          context "when #{cat}" do
            let(:category) { cat.to_sym }

            context 'when local' do
              let(:imported?) { false }
              it { is_expected.to eq '0.0' }
            end

            context 'when imported' do
              let(:imported?) { true }
              it { is_expected.to eq '0.6' }
            end
          end
        end
      end

      context 'when basic applicable' do
        let(:category) { :other }

        context 'when local' do
          let(:imported?) { false }
          it { is_expected.to eq '1.15' }
        end

        context 'when imported' do
          let(:imported?) { true }
          it { is_expected.to eq '1.7' }
        end
      end
    end
  end
end

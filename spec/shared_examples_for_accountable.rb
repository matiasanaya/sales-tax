RSpec.shared_examples 'a accountable' do
  describe '#to_hash' do
    subject { object.to_hash }

    it { is_expected.to be_instance_of Hash }

    it { is_expected.to include :unit_sales_tax, :total_unit_price }
  end
end

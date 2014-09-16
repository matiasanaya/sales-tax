RSpec.shared_examples 'a taxable' do
  describe '#unit_price_str' do
    subject { object.send(:unit_price_str) }
    it { is_expected.to be_instance_of String }
  end

  describe '#imported?' do
    subject { object.send(:imported?) }
    it { is_expected.to satisfy { |v| v.instance_of?(TrueClass) || v.instance_of?(FalseClass) } }
  end

  describe '#category' do
    subject { object.send(:category) }
    it { is_expected.to be_instance_of Symbol }
  end
end

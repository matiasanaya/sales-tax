RSpec.shared_examples 'a accountable' do
  subject { object }
  describe 'the public interface' do
    it { is_expected.to respond_to :unit_sales_tax }
  end
end

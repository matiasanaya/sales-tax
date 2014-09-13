require_relative '../../lib/sales_tax'

RSpec.describe SalesTax::Application do

  let(:app) { lambda { |f| SalesTax::Application.new(input: f).run } }

  context 'when cart is provided' do

    shared_examples 'a receipt printer' do |cart, receipt|
      it 'prints the correct receipt' do
        expect { app.call(cart) }.to output(receipt).to_stdout
      end
    end

    context 'from data/example_input_a.txt' do
      cart = File.open('data/example_input_a.txt', 'r')

      correct_receipt = <<-END.gsub(/^\s+\|/, '')
        |1, book, 12.49
        |1, music CD, 16.49
        |1, chocolate bar, 0.85
        |
        |Sales Taxes: 1.50
        |Total: 29.83
      END

      it_behaves_like 'a receipt printer', cart, correct_receipt
    end

    context 'from data/example_input_b.txt' do
      cart = File.open('data/example_input_b.txt', 'r')

      correct_receipt = <<-END.gsub(/^\s+\|/, '')
        |1, imported box of chocolates, 10.50
        |1, imported bottle of perfume, 54.65
        |
        |Sales Taxes: 7.65
        |Total: 65.15
      END

      it_behaves_like 'a receipt printer', cart, correct_receipt
    end

    context 'from data/example_input_c.txt' do
      cart = File.open('data/example_input_c.txt', 'r')

      correct_receipt = <<-END.gsub(/^\s+\|/, '')
        |1, imported bottle of perfume, 32.19
        |1, bottle of perfume, 20.89
        |1, packet of headache pills, 9.75
        |1, imported box of chocolates, 11.85
        |
        |Sales Taxes: 6.70
        |Total: 74.68
      END

      it_behaves_like 'a receipt printer', cart, correct_receipt
    end
  end
end

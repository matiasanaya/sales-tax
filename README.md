Sales Tax
==========

A basic sales tax calculator.

## Installation

via RubyGems:

    $ gem install salestax


## Usage

Pipe in a file with items:

    $ salestax < path/to/file

An example file with items:

    1, book, 12.49
    1, music CD, 14.99
    1, chocolate bar, 0.85

To which the calculator will print:

    1, book, 12.49
    1, music CD, 16.49
    1, chocolate bar, 0.85

    Sales Taxes: 1.50
    Total: 29.83

More example files can be found at `data/`

## Dependencies

    ruby version ~> 2.1.0p0

To check your version run:

    $ ruby -v

To learn how to install ruby visit [ruby-lang.org/en/installation/](https://www.ruby-lang.org/en/installation/)


## Troubleshooting

### Development environment

 * OSX 10.8.5, ruby 2.1.2p95

Development dependencies:

    rspec ~> 3.1

To install them along the gem:

    $ gem install --dev salestax

### Compatible environments

* Ubuntu 12.04 x32, ruby 2.1.0p0

### Incompatible environments

* ruby < 2.1.0

### Tests

To run the specs:

    $ rspec

To run just the integration tests:

    $ rspec spec/features

## Overview

The application is designed to read items from `$stdin` and print the receipt to `$stdout`.

### Input Format

Items feed into the program are expected to be comma-separated values with the following format:

    <quantity>, <description>, <unit_price>

Example:

    1, book, 12.49

Please note the blank space between the commas and `<description>` / `<unit_price>`, since it is required.

Each row in the input represents a line item of the receipt.

#### Quantity

Quantity is expected to be a whole value, thus only digits are allowed.

#### Description

Anything but a comma character is allowed in the description. They must contain at least one word character (letter, number, underscore).

* Imported items should contain 'imported' in the description.

* Food items should contain 'chocolate' in the description.

* Medicine items should contain 'headache' in the description.

* Book items should contain 'book' in the description.

#### Unit price

Unit price is expected to be a decimal value, though it can be a whole one as well. A '.' is expected as the fractional separator.

### Output Format

A receipt will be printed that lists the name of all the items and their price (including tax), finishing with the total cost of the items, and the total amounts of sales taxes paid.

Example:

    1, book, 12.49
    1, music CD, 16.49
    1, chocolate bar, 0.85

    Sales Taxes: 1.50
    Total: 29.83

### Taxing rules

Basic sales tax is applicable at a rate of 10% on all goods, except books, food, and medical products that are exempt. Import duty is an additional sales tax applicable on all imported goods at a rate of 5%, with no exemptions.

The rounding rules for sales tax are that for a tax rate of n%, a shelf price of p, it contains np/100 (rounded up to the nearest 0.05) amount of sales tax.

### Examples

#### Example A

Input:

    1, book, 12.49
    1, music CD, 14.99
    1, chocolate bar, 0.85

Output:

    1, book, 12.49
    1, music CD, 16.49
    1, chocolate bar, 0.85

    Sales Taxes: 1.50
    Total: 29.83

#### Example B

Input:

    1, imported box of chocolates, 10.00
    1, imported bottle of perfume, 47.50

Output:

    1, imported box of chocolates, 10.50
    1, imported bottle of perfume, 54.65

    Sales Taxes: 7.65
    Total: 65.15

#### Example C

Input:

    1, imported bottle of perfume, 27.99
    1, bottle of perfume, 18.99
    1, packet of headache pills, 9.75
    1, box of imported chocolates, 11.25

Output:

    1, imported bottle of perfume, 32.19
    1, bottle of perfume, 20.89
    1, packet of headache pills, 9.75
    1, box of imported chocolates, 11.85

    Sales Taxes: 6.70
    Total: 74.68

## Design

The application flows in the following way:

#### 1 Launch

    $ salestax < path/to/file

##### 1.1 bin/salestax

The `salestax` in the command is a ruby executable in your load path. This executable contains the following lines:

```ruby
require 'sales_tax'
SalesTax::Application.new.run
```

The first line requires the file `./lib/sales_tax.rb` which loads the library. The second line creates and instance of the application.

##### 1.2 lib/sales_tax/application.rb

The `#run` method reads in items from the input source (defaults to `$stdin`) and passes them to the parser. The parser returns (might) a structured item which is added to the receipt.

```ruby
def run
  loop do
    raw_input = input.gets
    break unless raw_input
    raw_input.chomp!
    line_item = parser.parse(raw_input)
    receipt.add_item(line_item) if line_item
  end
  puts receipt.print
end
```

##### 1.2.1 lib/sales_tax/line_item/parser.rb

`parser.parse()` first calls a `@input_validator` function which checks the formating of the input. It the pre-process the input into a basic hash composed of the quantity, description and price of the item. It finally delegates the heavy lifting to the augmenter function which is in charge of extending the hash with actual taxing info.

```ruby
def parse(_in)
  @input_validator.call(_in)
  @augmenter.call(@pre_processor.call(_in))
end
```

The `@augmenter` function delegates the actual augmenting feature to the augmenters, which in this case are hard-coded. The augmenters need to respond to the `#augment` message and either return the augmented hash or `nil` if they do not understand it.

```ruby
@augmenter = lambda do |_in|
  augmented = nil
  [LineItem::Book, LineItem::Medicine, LineItem::Food].each do |augmenter|
    augmented = augmenter.augment(_in)
    break if augmented
  end
  augmented || LineItem::Base.augment(_in)
end
```

This function will return the first augmented hash it encounters or whatever `LineItem::Base.augment(_in)` returns.

##### 1.2.1.1 lib/sales_tax/line_item/base.rb

```ruby
def self.augment(attributes)
  new(attributes).to_hash if attributes[:description] =~ description_matcher
end
```

This is the base method which `LineItem::(Food/Book/Medicine)` inherit. It tries to recognize the description in the hash, and if successful it will augment it.

Augmenting it will actually involve a long series of messages, which I will not cover here. All of them are contained within `lib/sales_tax/line_item/base.rb` and `lib/sales_tax/accountable.rb`

#### 1.2.2 lib/sales_tax/receipt.rb

Next line in `Application#run` is:

```ruby
receipt.add_item(line_item) if line_item
```

This simply adds the `line_item`, which is actually a hash, to a @items array in the receipt.

```ruby
def add_item(item)
  items << item
end
```

This will be done for every line item. After all items have been added, the application prints the receipt:

```ruby
puts receipt.print
```

Printing will return a string with all the items printed out, as well as totals and sales tax totals.

```ruby
def print
  _print = ''
  _print << print_items
  _print << "\n"
  _print << print_totals
  _print
end
```

#### 2 Exit

After the receipt is printed, the application exits.


## Discussion

My main design decisions / concerns in no specific order are:

* `Accountable` depends on a `Taxable` role which only has a private interface. This is weird. A object should not depend on a private interface. The alternative here is to make that interface public (`#category`, `#imported?`, `#unit_price_str`), but that would make the `LineItem::Base` class to expose much more than I like. Another possible solution would be to make `Accountable` a class instead of a module, so that these messages can be passed as arguments. I liked the module approach better, which ended up bitting.

* There is a pending test for `LineItem::Parser.parse` which should test that the method delegates the augmentation part of it. This behavior is only covered by the integration test. Implementing this test would mean having the dependencies injected into the parser, which is better and that is why the pending test is left there.

*  `Receipt#print` loops two times through the `@items` array. One for printing the items, the second for calculating the totals. I found this to be more readable since it allowed me to break the method into sub-routines.

* The quantity property of items is ignored since there is not enough information in the spec to decide what should be done with it. There is a [issue hosted on github](https://github.com/matiasanaya/sales-tax/issues/1) for this.

* I found input inconsistencies which I did not know how to manage. The decision was to re-format the input and open [another issue](https://github.com/matiasanaya/sales-tax/issues/2)

### Subtleties

In `spec/shared_examples_for_line_item_base.rb` the following line:

```
it { expect(described_class).to respond_to :augment }
```
prints:

    SalesTax::LineItem::Base
      behaves like a line item
        the public interface
          should respond to #augment

This should read `should respond to .augment` since it is a method on the class.

## Contributing

View [CONTRIBUTING.md](https://github.com/matiasanaya/sales-tax/blob/master/CONTRIBUTING.md)

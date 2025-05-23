# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::RedundantWithIndex, :config do
  it 'registers an offense for `ary.each_with_index { |v| v }` and corrects to `ary.each`' do
    expect_offense(<<~RUBY)
      ary.each_with_index { |v| v }
          ^^^^^^^^^^^^^^^ Use `each` instead of `each_with_index`.
    RUBY

    expect_correction(<<~RUBY)
      ary.each { |v| v }
    RUBY
  end

  it 'registers an offense for `ary&.each_with_index { |v| v }` and corrects to `ary&.each`' do
    expect_offense(<<~RUBY)
      ary&.each_with_index { |v| v }
           ^^^^^^^^^^^^^^^ Use `each` instead of `each_with_index`.
    RUBY

    expect_correction(<<~RUBY)
      ary&.each { |v| v }
    RUBY
  end

  it 'registers an offense when using `ary.each.with_index { |v| v }` and corrects to `ary.each`' do
    expect_offense(<<~RUBY)
      ary.each.with_index { |v| v }
               ^^^^^^^^^^ Remove redundant `with_index`.
    RUBY

    expect_correction(<<~RUBY)
      ary.each { |v| v }
    RUBY
  end

  it 'registers an offense when using `ary.each.with_index(1) { |v| v }` ' \
     'and correct to `ary.each { |v| v }`' do
    expect_offense(<<~RUBY)
      ary.each.with_index(1) { |v| v }
               ^^^^^^^^^^^^^ Remove redundant `with_index`.
    RUBY

    expect_correction(<<~RUBY)
      ary.each { |v| v }
    RUBY
  end

  it 'registers an offense when using ' \
     '`ary.each_with_object([]).with_index { |v| v }` ' \
     'and corrects to `ary.each_with_object([]) { |v| v }`' do
    expect_offense(<<~RUBY)
      ary.each_with_object([]).with_index { |v| v }
                               ^^^^^^^^^^ Remove redundant `with_index`.
    RUBY

    expect_correction(<<~RUBY)
      ary.each_with_object([]) { |v| v }
    RUBY
  end

  it 'accepts an index is used as a block argument' do
    expect_no_offenses('ary.each_with_index { |v, i| v; i }')
  end

  context 'Ruby 2.7', :ruby27 do
    it 'registers an offense for `ary.each_with_index { _1 }` and corrects to `ary.each`' do
      expect_offense(<<~RUBY)
        ary.each_with_index { _1 }
            ^^^^^^^^^^^^^^^ Use `each` instead of `each_with_index`.
      RUBY

      expect_correction(<<~RUBY)
        ary.each { _1 }
      RUBY
    end

    it 'registers an offense for `ary&.each_with_index { _1 }` and corrects to `ary&.each`' do
      expect_offense(<<~RUBY)
        ary&.each_with_index { _1 }
             ^^^^^^^^^^^^^^^ Use `each` instead of `each_with_index`.
      RUBY

      expect_correction(<<~RUBY)
        ary&.each { _1 }
      RUBY
    end

    it 'registers an offense when using `ary.each.with_index { _1 }` and corrects to `ary.each`' do
      expect_offense(<<~RUBY)
        ary.each.with_index { _1 }
                 ^^^^^^^^^^ Remove redundant `with_index`.
      RUBY

      expect_correction(<<~RUBY)
        ary.each { _1 }
      RUBY
    end

    it 'accepts an index is used as a numblock argument' do
      expect_no_offenses('ary.each_with_index { _1; _2 }')
    end

    it 'accepts with_index with receiver and a block' do
      expect_no_offenses('ary.with_index { |v| v }')
    end

    it 'accepts with_index without receiver with a block' do
      expect_no_offenses('with_index { |v| v }')
    end

    it 'accepts with_index without receiver with a numblock' do
      expect_no_offenses('with_index { _1 }')
    end
  end

  context 'Ruby 3.4', :ruby34 do
    it 'registers an offense for `ary.each_with_index { it }` and corrects to `ary.each`' do
      expect_offense(<<~RUBY)
        ary.each_with_index { it }
            ^^^^^^^^^^^^^^^ Use `each` instead of `each_with_index`.
      RUBY

      expect_correction(<<~RUBY)
        ary.each { it }
      RUBY
    end

    it 'registers an offense for `ary&.each_with_index { it }` and corrects to `ary&.each`' do
      expect_offense(<<~RUBY)
        ary&.each_with_index { it }
             ^^^^^^^^^^^^^^^ Use `each` instead of `each_with_index`.
      RUBY

      expect_correction(<<~RUBY)
        ary&.each { it }
      RUBY
    end

    it 'registers an offense when using `ary.each.with_index { it }` and corrects to `ary.each`' do
      expect_offense(<<~RUBY)
        ary.each.with_index { it }
                 ^^^^^^^^^^ Remove redundant `with_index`.
      RUBY

      expect_correction(<<~RUBY)
        ary.each { it }
      RUBY
    end

    it 'accepts with_index without receiver with an itblock' do
      expect_no_offenses('with_index { it }')
    end
  end
end

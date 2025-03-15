# typed: true
# frozen_string_literal: true

require("minitest/autorun")
require("toggler")

module Minitest::Assertions
  def assert_something_in_block
    yield
  end
end

class Subject
  def initialize(flag)
    @flag = flag
  end

  def foo(beta1, beta2)
    return false if !beta1
    return false if !beta2
    return false if !@flag

    true
  end
end

class MyTest < ::Minitest::Test
  def setup
    @scenario = Toggler::Scenario.new(
      default_args: {
        flag: 123,
        beta1: true,
        beta2: true,
      }
    ) do |args|
      subject = Subject.new(args[:flag])
      result = subject.foo(args[:beta1], args[:beta2])
      result
    end
  end

  def test_happy
    @scenario.expect { assert(_1) }
  end

  def test_false_when_missing_beta1
    @scenario.with_args(beta1: true, beta2: false).expect { refute(_1) }
  end

  def test_with_block_style_assertion
    assert_something_in_block do
      @scenario.expect { assert(_1) }
    end
  end
end

# frozen_string_literal: true
# typed: true

require("minitest/autorun")
require_relative("../lib/toggler")

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
  end

  def test_happy
    subject = Subject.new(true)
    result = subject.foo(true, true)

    assert(result)
  end

  def test_toggle
    toggler = Toggler.new(
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

    toggler
      .add_scenario("default test case")
      .expect { assert(_1) }
      .build

    toggler
      .add_scenario("default test case")
      .with_args(beta1: true, beta2: false)
      .expect { assert(_1) }
      .build

    toggler.run
  end
end

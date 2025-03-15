# typed: strict
# frozen_string_literal: true

class Toggler
  class ScenarioBuilder
    extend(T::Sig)
    extend(T::Helpers)

    # requires_ancestor { Minitest::Assertions }

    sig do
      params(
        toggler: Toggler,
        name: String,
      ).void
    end
    def initialize(toggler, name)
      @toggler = toggler
      @name = name
      @args = T.let({}, ArgsType)
      @expectation = T.let(nil, T.nilable(ExpectationType))
    end

    sig do
      params(
        args: T.untyped,
      ).returns(T.self_type)
    end
    def with_args(**args)
      @args = args
      self
    end

    sig { params(block: ExpectationType).returns(T.self_type) }
    def expect(&block)
      @expectation = block
      self
    end

    sig { void }
    def build
      raise if @expectation.nil?

      @toggler.scenarios.push(Scenario.new(name: @name, args: @args, expectation: @expectation))
    end
  end
end

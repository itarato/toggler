# typed: strict
# frozen_string_literal: true

class Toggler
  class Scenario
    extend(T::Sig)

    sig { returns(ArgsType) }
    attr_reader(:args)

    sig { returns(ExpectationType) }
    attr_reader(:expectation)

    sig do
      params(
        name: String,
        args: ArgsType,
        expectation: ExpectationType,
      ).void
    end
    def initialize(name:, args:, expectation:)
      @name = name
      @args = args
      @expectation = expectation
    end
  end
end
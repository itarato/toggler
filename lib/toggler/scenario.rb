# typed: strict
# frozen_string_literal: true

class Toggler
  class Scenario
    extend(T::Sig)

    sig do
      params(
        default_args: ArgsType,
        template_block: T.proc.params(args: ArgsType).returns(T.untyped),
      ).void
    end
    def initialize(default_args:, &template_block)
      @args = default_args
      @template_block = template_block
    end

    sig do
      params(
        scenario_args: T.untyped,
      ).returns(T.self_type)
    end
    def with_args(**scenario_args)
      @args.merge!(scenario_args)
      self
    end

    sig do
      params(
        assert_block: ExpectationType,
      ).void
    end
    def expect(&assert_block)
      result = @template_block[@args]
      assert_block[result]
    end
  end
end
# typed: strict
# frozen_string_literal: true

module Toggler
  class Scenario
    extend(T::Sig)

    ArgsType = T.type_alias { T::Hash[Symbol, T.untyped] }
    ExpectationType = T.type_alias { T.proc.params(result: T.untyped).void }
    TemplateType = T.type_alias { T.proc.params(args: ArgsType).returns(T.untyped) }

    sig do
      params(
        default_args: ArgsType,
        template_block: TemplateType,
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
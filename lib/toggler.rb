# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

require_relative("toggler/args")
require_relative("toggler/scenario")
require_relative("toggler/scenario_builder")

class Toggler
  extend(T::Sig)

  ArgsType = T.type_alias { T::Hash[Symbol, T.untyped] }
  ExpectationType = T.type_alias { T.proc.params(result: T.untyped).void }

  sig { returns(T::Array[Toggler::Scenario]) }
  attr_reader(:scenarios)

  sig do
    params(
      default_args: T::Hash[Symbol, T.untyped],
      block: T.proc.params(args: ArgsType).returns(T.untyped),
    ).void
  end
  def initialize(default_args: {}, &block)
    @default_args = default_args
    @block = block
    @scenarios = T.let([], T::Array[Toggler::Scenario])
  end

  sig do
    params(
      name: String,
    ).returns(Toggler::ScenarioBuilder)
  end
  def add_scenario(name)
    ScenarioBuilder.new(self, name)
  end

  sig { void }
  def run
    @scenarios.each do |scenario|
      args = @default_args.clone
      args.merge!(scenario.args)

      result = @block.call(args)

      scenario.expectation.call(result)
    end
  end
end

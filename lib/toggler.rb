# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

require_relative("toggler/scenario")

class Toggler
  extend(T::Sig)

  ArgsType = T.type_alias { T::Hash[Symbol, T.untyped] }
  ExpectationType = T.type_alias { T.proc.params(result: T.untyped).void }
end

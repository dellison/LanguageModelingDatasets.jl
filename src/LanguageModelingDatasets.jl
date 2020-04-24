module LanguageModelingDatasets

export BillionWordBenchmark
export HutterPrize
export WikiText2, WikiText103, WikiText2Raw, WikiText103Raw
export PennTreebank

using DataDeps

abstract type AbstractLanguageModelingDataset end

abstract type       AbstractTokenType end
struct Word      <: AbstractTokenType end
struct Character <: AbstractTokenType end
struct Sentence  <: AbstractTokenType end # ?

include("util.jl")

include("datasets/billion_word_benchmark.jl")
include("datasets/wikitext.jl")
include("datasets/enwiki8.jl")
include("datasets/ptb.jl")

using .BillionWordBenchmark, .WikiText , .HutterPrize, .PennTreebank

end # module

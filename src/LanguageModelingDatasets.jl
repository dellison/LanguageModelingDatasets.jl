module LanguageModelingDatasets

using DataDeps

abstract type AbstractLanguageModelingDataset end

abstract type TokenType end
struct Word <: TokenType end
struct Character <: TokenType end

include("api.jl")
include("util.jl")

include("datasets/billion_word_benchmark.jl")
include("datasets/wikitext.jl")
include("datasets/enwiki8.jl")
using .BillionWordBenchmark, .WikiText , .HutterPrize

# function __init__()
    # register_billionwordbenchmark()
    # register_wikitext()
    # register_enwiki8()
# end

end # module

module LanguageModelingDatasets

using DataDeps

export BillionWordBenchmark
export WikiText2, WikiText103, WikiText2Raw, WikiText103Raw
export HutterPrize, enwiki8

export train_files, dev_files, test_files

export read_tokens, train_tokens, dev_tokens, test_tokens
export read_sentences, train_sentences, dev_sentences, test_sentences

abstract type AbstractLanguageModelingDataset end

# 
abstract type TokenType end
struct Word <: TokenType end
struct Character <: TokenType end

include("api.jl")
include("util.jl")
include("datasets/billion_word_benchmark.jl")
include("datasets/wikitext.jl")
include("datasets/enwiki8.jl")

function __init__()
    register_billionwordbenchmark()
    register_wikitext()
    register_enwiki8()
end

end # module

module LanguageModelingDatasets

using DataDeps

export BillionWordBenchmark
export WikiText2, WikiText103, WikiText2Raw, WikiText103Raw
export HutterPrize, enwiki8

export train_files, dev_files, test_files

"""
    train_files(corpus)

todo
"""
function train_files end

"""
    dev_files(corpus)

todo
"""
function dev_files end

"""
    test_files(corpus)

todo
"""
function test_files end

abstract type AbstractLanguageModelingDataset end

include("datasets/billion_word_benchmark.jl")
include("datasets/wikitext.jl")
include("datasets/enwiki8.jl")

function __init__()
    register_billionwordbenchmark()
    register_wikitext()
    register_enwiki8()
end

end # module

module BillionWordBenchmark

using DataDeps
import ...AbstractLanguageModelingDataset, ...MultiFileTokenIterator
import ...read_word, ...read_sentence

train_files(;ks...) = train_files(BillionWordBenchmarkDataset(); ks...)
dev_files(;ks...)   = dev_files(BillionWordBenchmarkDataset(); ks...)
test_files(; ks...) = test_files(BillionWordBenchmarkDataset(); ks...)

train_sentences(;ks...) = train_sentences(BillionWordBenchmarkDataset(); ks...)
dev_sentences(;ks...)   = dev_sentences(BillionWordBenchmarkDataset(); ks...)
test_sentences(; ks...) = test_sentences(BillionWordBenchmarkDataset(); ks...)

train_tokens(; ks...) = train_tokens(BillionWordBenchmarkDataset(); ks...)
dev_tokens(; ks...)   = dev_tokens(BillionWordBenchmarkDataset(); ks...)
test_tokens(; ks...)  = test_tokens(BillionWordBenchmarkDataset(); ks...)

struct BillionWordBenchmarkDataset <: AbstractLanguageModelingDataset end

tokentype(::Type{BillionWordBenchmarkDataset}) = Word()

bwb_dir(paths...) =
    joinpath(datadep"billionwordbenchmark",
             "1-billion-word-language-modeling-benchmark-r13output",
             paths...)

struct BillionWordBenchmarkTokens
    tokens::MultiFileTokenIterator
end

Base.IteratorSize(::Type{BillionWordBenchmarkTokens}) = Base.SizeUnknown()
Base.IteratorEltype(::Type{BillionWordBenchmarkTokens}) = Base.HasEltype()
Base.eltype(::BillionWordBenchmarkTokens) = String
Base.iterate(bwb::BillionWordBenchmarkTokens, state...) = iterate(bwb.tokens, state...)

function train_files(::BillionWordBenchmarkDataset)
    dir = bwb_dir("training-monolingual.tokenized.shuffled")
    return filter(isfile, map(x -> joinpath(dir, x), readdir(dir)))
end

dev_files(::BillionWordBenchmarkDataset) = ()

function test_files(::BillionWordBenchmarkDataset)
    dir = bwb_dir("heldout-monolingual.tokenized.shuffled")
    return filter(isfile, map(x -> joinpath(dir, x), readdir(dir)))
end

train_tokens(bwb::BillionWordBenchmarkDataset) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(train_files(bwb), read_word))

dev_tokens(::BillionWordBenchmarkDataset) = ()

test_tokens(bwb::BillionWordBenchmarkDataset) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(test_files(bwb), read_word))

train_sentences(bwb::BillionWordBenchmarkDataset; kw...) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(train_files(bwb), x -> read_sentence(x, kw...)))

dev_sentences(::BillionWordBenchmarkDataset) = ()

test_sentences(bwb::BillionWordBenchmarkDataset; kw...) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(test_files(bwb), x -> read_sentence(x, kw...)))

function __init__()
    DataDeps.register(DataDep(
        "billionwordbenchmark",
        """
        todo
        """,
        "http://www.statmt.org/lm-benchmark/1-billion-word-language-modeling-benchmark-r13output.tar.gz",
        "01ba60381110baf7f189dfd2b8374de371e8c9a340835793f190bdae9e90a34e",
        fetch_method = (r, l) -> DataDeps.fetch_http(r, l; update_period=10),
        post_fetch_method=unpack
    ))
end

end

struct BillionWordBenchmark <: AbstractLanguageModelingDataset end

tokentype(::Type{BillionWordBenchmark}) = Word()

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

function train_files(::BillionWordBenchmark)
    dir = bwb_dir("training-monolingual.tokenized.shuffled")
    return filter(isfile, map(x -> joinpath(dir, x), readdir(dir)))
end

dev_files(::BillionWordBenchmark) = ()

function test_files(::BillionWordBenchmark)
    dir = bwb_dir("heldout-monolingual.tokenized.shuffled")
    return filter(isfile, map(x -> joinpath(dir, x), readdir(dir)))
end

train_tokens(bwb::BillionWordBenchmark) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(train_files(bwb), read_word))

dev_tokens(::BillionWordBenchmark) = ()

test_tokens(bwb::BillionWordBenchmark) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(test_files(bwb), read_word))

train_sentences(bwb::BillionWordBenchmark; kw...) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(train_files(bwb), x -> read_sentence(x, kw...)))

dev_sentences(::BillionWordBenchmark) = ()

test_sentences(bwb::BillionWordBenchmark; kw...) =
    BillionWordBenchmarkTokens(MultiFileTokenIterator(test_files(bwb), x -> read_sentence(x, kw...)))

function register_billionwordbenchmark()
    DataDeps.register(DataDep(
        "billionwordbenchmark",
        """
        todo
        """,
        "http://www.statmt.org/lm-benchmark/1-billion-word-language-modeling-benchmark-r13output.tar.gz",
        "01ba60381110baf7f189dfd2b8374de371e8c9a340835793f190bdae9e90a34e",
        post_fetch_method=unpack
    ))
end

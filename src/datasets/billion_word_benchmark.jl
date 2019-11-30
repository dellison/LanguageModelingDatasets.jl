struct BillionWordBenchmark <: AbstractLanguageModelingDataset end

tokentype(::Type{BillionWordBenchmark}) = Word()

bwb_dir(paths...) =
    joinpath(datadep"billionwordbenchmark",
             "1-billion-word-language-modeling-benchmark-r13output",
             paths...)

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
    MultiFileTokenIterator(train_files(bwb), read_word)

dev_tokens(::BillionWordBenchmark) = ()

test_tokens(bwb::BillionWordBenchmark) =
    MultiFileTokenIterator(test_files(bwb), read_word)

train_sentences(bwb::BillionWordBenchmark; kw...) =
    MultiFileTokenIterator(train_files(bwb), x -> read_sentence(x, kw...))

dev_sentences(::BillionWordBenchmark) = ()

test_sentences(bwb::BillionWordBenchmark; kw...) =
    MultiFileTokenIterator(test_files(bwb), x -> read_sentence(x, kw...))

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

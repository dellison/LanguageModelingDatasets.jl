"""
    BillionWordBenchmark

TODO
"""
module BillionWordBenchmark

using DataDeps
import ...AbstractLanguageModelingDataset, ...CorpusReader, ...Word, ...Sentence
import ...read_word, ...read_sentence

struct BillionWordBenchmarkDataset <: AbstractLanguageModelingDataset end

const BWB = BillionWordBenchmarkDataset
const BWBReader{S,T} = CorpusReader{BWB,S,T}

const UNK = "<UNK>"

train_files() = bwb_files("training-monolingual.tokenized.shuffled")
dev_files()   = ()
test_files()  = bwb_files("heldout-monolingual.tokenized.shuffled")

train_sentences(;ks...) = bwb_sentences(train_files(), :train; ks...)
dev_sentences(;ks...)   = ()
test_sentences(;ks...)  = bwb_sentences(test_files(), :test; ks...)

train_tokens() = bwb_reader(train_files(), :train, read_word, Word)
dev_tokens()   = ()
test_tokens()  = bwb_reader(test_files(), :test, read_word, Word)

bwb_dir(paths...) =
    joinpath(datadep"billionwordbenchmark",
             "1-billion-word-language-modeling-benchmark-r13output",
             paths...)

function bwb_files(paths)
    dir = bwb_dir(paths)
    return filter(isfile, map(x -> joinpath(dir, x), readdir(dir)))
end

bwb_reader(files, set, tokenize, T) =
    CorpusReader(BWB(), set, files, tokenize, T)

bwb_sentences(files, set; ks...) =
    bwb_reader(files, set, x -> read_sentence(x; ks...), Sentence)

Base.length(::BWBReader{:train,Sentence}) = 30301028
Base.length(::BWBReader{:dev,Sentence})   = 0
Base.length(::BWBReader{:test,Sentence})  = 613376
Base.length(::BWBReader{:train,Word})     = 7686488840
Base.length(::BWBReader{:dev,Word})       = 0
Base.length(::BWBReader{:test,Word})      = 155800220

for SetT in (:train,:dev,:test), TokenT in (Sentence, Word)
    Base.IteratorSize(::Type{<:BWBReader{SetT,TokenT}}) = Base.HasLength()
end

function __init__()
    DataDeps.register(DataDep(
        "billionwordbenchmark",
        """
        todo
        """,
        "http://www.statmt.org/lm-benchmark/1-billion-word-language-modeling-benchmark-r13output.tar.gz",
        "01ba60381110baf7f189dfd2b8374de371e8c9a340835793f190bdae9e90a34e",
        fetch_method = (r, l) -> DataDeps.fetch_http(r, l; update_period=10),
        post_fetch_method = unpack
    ))
end

end # module

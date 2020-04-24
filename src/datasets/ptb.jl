"""
    PennTreebank

TODO
"""
module PennTreebank

using DataDeps
import ...AbstractLanguageModelingDataset, ...CorpusReader, ...Word, ...Sentence
import ...read_word, ...read_sentence

struct PennTreebankDataset <: AbstractLanguageModelingDataset end

const PTB = PennTreebankDataset
const PTBReader{S,T} = CorpusReader{PTB,S,T}

const UNK = "<unk>"

train_files() = [ptb_dir("ptb.train.txt")]
dev_files()   = [ptb_dir("ptb.valid.txt")]
test_files()  = [ptb_dir("ptb.test.txt")]

train_sentences(;ks...) = ptb_sentences(train_files(), :train; ks...)
dev_sentences(;ks...)   = ptb_sentences(dev_files(), :dev, ks...)
test_sentences(;ks...)  = ptb_sentences(test_files(), :test; ks...)

train_tokens() = ptb_reader(train_files(), :train, read_word, Word)
dev_tokens()   = ptb_reader(dev_files(), :dev, read_word, Word)
test_tokens()  = ptb_reader(test_files(), :test, read_word, Word)

ptb_dir(paths...) = joinpath(datadep"ptb_lm", paths...)

ptb_reader(files, set, tokenize, T) =
    CorpusReader(PTB(), set, files, tokenize, T)

ptb_sentences(files, set; ks...) =
    ptb_reader(files, set, x -> read_sentence(x; ks...), Sentence)

Base.length(::PTBReader{:train,Sentence}) = 42068
Base.length(::PTBReader{:dev,Sentence})   = 3370
Base.length(::PTBReader{:test,Sentence})  = 3761
Base.length(::PTBReader{:train,Word})     = 887521
Base.length(::PTBReader{:dev,Word})       = 70390
Base.length(::PTBReader{:test,Word})      = 78669

for SetT in (:train,:dev,:test), TokenT in (Sentence, Word)
    Base.IteratorSize(::Type{<:PTBReader{SetT,TokenT}}) = Base.HasLength()
end

Base.show(io::IO, r::PTBReader{S,Sentence}) where S =
    print("PTB Dataset ($(length(r)) sentences)")
Base.show(io::IO, r::PTBReader{S,Word}) where S =
    print("PTB Dataset ($(length(r)) tokens)")

function __init__()
    commit = "76870253cfca069477f06b7056af87f98490b6eb"
    DataDeps.register(DataDep(
        "ptb_lm",
        """
        todo
        """,
        "https://github.com/wojzaremba/lstm/archive/$commit.zip",
        "1d16a164cb241f66a224475cb4b8964572e2ac0b881087e5654e6790c3c69671",
        fetch_method = (r, l) -> DataDeps.fetch_http(r, l; update_period=10),
        post_fetch_method = zip -> begin
            unpack(zip)
            cd("lstm-$commit") do
                for file in ("ptb.train.txt", "ptb.valid.txt", "ptb.test.txt")
                    mv(joinpath("data", file), joinpath("..", file))
                end
            end
            rm("lstm-$commit", recursive=true)
        end
    ))
end

end # module

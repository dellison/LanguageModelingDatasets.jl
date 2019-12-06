module WikiText

export WikiText2, WikiText103, WikiText2Raw, WikiText103Raw

import ...AbstractLanguageModelingDataset
import ...CorpusReader, ...read_word, ...read_char

"""
    WikiText2

WikiText2 corpus for word-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
module WikiText2

using DataDeps
import ...AbstractLanguageModelingDataset, ...CorpusReader, ...read_word

struct WikiText2Corpus <: AbstractLanguageModelingDataset end

dir() = datadep"WikiText-2-v1"

all_files()   = [train_file(), dev_file(), test_file()]
train_files() = [joinpath(dir(), "wiki.train.tokens")]
dev_files()   = [joinpath(dir(), "wiki.valid.tokens")]
test_files()  = [joinpath(dir(), "wiki.test.tokens")]

train_file() = joinpath(dir(), "wiki.train.tokens")
dev_file()   = joinpath(dir(), "wiki.valid.tokens")
test_file()  = joinpath(dir(), "wiki.test.tokens")

all_tokens()   = Iterators.flatten((train_tokens(), dev_tokens(), test_tokens()))
train_tokens() = CorpusReader(WikiText2Corpus(), :train, train_files(), read_word)
dev_tokens()   = CorpusReader(WikiText2Corpus(), :dev,   dev_files(),   read_word)
test_tokens()  = CorpusReader(WikiText2Corpus(), :test,  test_files(),  read_word)

all_sentences() = Iterators.flatten((train_sentences(), dev_sentences(), test_sentences()))
train_sentences() = CorpusReader(WikiText2Corpus(), :train, train_files(), read_sentence)
dev_sentences()   = CorpusReader(WikiText2Corpus(), :dev,   dev_files(),   read_sentence)
test_sentences()  = CorpusReader(WikiText2Corpus(), :test,  test_files(),  read_sentence)

# Base.length(::CorpusReader
    # w.set == :train ? 2051910 :
    # w.set == :valid ? 213886  :
    # w.set == :test  ? 241211  :

function __init__()
    moveup = x -> mv(x, joinpath("..", x))
    DataDeps.register(DataDep(
        "WikiText-2-v1",
        """
        Dataset: WikiText-2 word level language modeling dataset
        Author: Stephen Merity
        License: CC-SA 3.0
        Website: https://einstein.ai/research/the-wikitext-long-term-dependency-language-modeling-dataset
        Size: 12MB (unzipped)

        Wikitext-2 word level long term dependency language modeling dataset.

        """,
        "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-2-v1.zip",
        "92675f1d63015c1c8b51f1656a52d5bdbc33aafa60cc47a218a66e7ee817488c",
        post_fetch_method = function (zip)
            unpack(zip)
            cd("wikitext-2") do
                moveup("wiki.train.tokens")
                moveup("wiki.test.tokens")
                moveup("wiki.valid.tokens")
            end
            rm("wikitext-2")
        end
    ))
end
end # WikiText2 module

"""
    WikiText103

WikiText103v1 corpus for word-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
module WikiText103

using DataDeps
import ...AbstractLanguageModelingDataset, ...CorpusReader, ...read_word

struct WikiText103Corpus <: AbstractLanguageModelingDataset end

const WT103 = WikiText103Corpus

dir() = datadep"WikiText-103-v1"

train_files() = [joinpath(dir(), "wiki.train.tokens")]
dev_files()   = [joinpath(dir(), "wiki.valid.tokens")]
test_files()  = [joinpath(dir(), "wiki.test.tokens")]

train_file() = joinpath(dir(), "wiki.train.tokens")
dev_file()   = joinpath(dir(), "wiki.valid.tokens")
test_file()  = joinpath(dir(), "wiki.test.tokens")

train_tokens() = CorpusReader(WikiText103Corpus(), :train, train_files(), read_word)
dev_tokens()   = CorpusReader(WikiText103Corpus(), :dev,   dev_files(),   read_word)
test_tokens()  = CorpusReader(WikiText103Corpus(), :test,  test_files(),  read_word)

train_sentences() = CorpusReader(WikiText103Corpus(), :train, train_files(), read_sentence)
dev_sentences()   = CorpusReader(WikiText103Corpus(), :dev,   dev_files(),   read_sentence)
test_sentences()  = CorpusReader(WikiText103Corpus(), :test,  test_files(),  read_sentence)

function __init__()
    moveup = x -> mv(x, joinpath("..", x))
    DataDeps.register(DataDep(
        "WikiText-103-v1",
        """
        Dataset: WikiText-103 word level language modeling dataset
        Author: Stephen Merity
        License: CC-SA 3.0
        Website: https://einstein.ai/research/the-wikitext-long-term-dependency-language-modeling-dataset
        Size: 516 MB
        
        Wikitext-103 word level long term dependency language modeling dataset.
      
        """,
        "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-103-v1.zip",
        "242ba0f20b329cfdf1ccc61e9e9e5b59becf189db7f7a81cd2a0e2fc31539590",
        post_fetch_method = function (zip)
            unpack(zip)
            cd("wikitext-103") do
                moveup("wiki.train.tokens")
                moveup("wiki.valid.tokens")
                moveup("wiki.test.tokens")
            end
            rm("wikitext-103")
        end
    ))
end
end # WikiText103 module


"""
    WikiText2RawV1

WikiText2RawV1 corpus for character-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
# struct WikiText2RawV1 <: WikiTextCorpus end
module WikiText2Raw

using DataDeps

struct WikiText2RawCorpus end

dir() = datadep"WikiText-2-raw-v1"

train_files() = [joinpath(dir(), "wiki.train.raw")]
dev_files()   = [joinpath(dir(), "wiki.valid.raw")]
test_files()  = [joinpath(dir(), "wiki.test.raw")]

train_file() = joinpath(dir(), "wiki.train.raw")
dev_file()   = joinpath(dir(), "wiki.valid.raw")
test_file()  = joinpath(dir(), "wiki.test.raw")

train_tokens() = CorpusReader(WikiText2Corpus(), :train, train_files(), read_word)
dev_tokens()   = CorpusReader(WikiText2Corpus(), :dev,   dev_files(),   read_word)
test_tokens()  = CorpusReader(WikiText2Corpus(), :test,  test_files(),  read_word)

train_sentences() = CorpusReader(WikiText2Corpus(), :train, train_files(), read_sentence)
dev_sentences()   = CorpusReader(WikiText2Corpus(), :dev,   dev_files(),   read_sentence)
test_sentences()  = CorpusReader(WikiText2Corpus(), :test,  test_files(),  read_sentence)

function __init__()
    moveup = x -> mv(x, joinpath("..", x))
    DataDeps.register(DataDep(
        "WikiText-2-raw-v1",
        """
        Dataset: WikiText-2 raw character level language modeling dataset
        Author: Stephen Merity
        License: CC-SA 3.0
        Website: https://einstein.ai/research/the-wikitext-long-term-dependency-language-modeling-dataset
        Size: 12 MB (unzipped)

        Wikitext-2 raw character level long term dependency language modeling dataset.

        """,
        "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-2-raw-v1.zip",
        "ef7edb566e3e2b2d31b29c1fdb0c89a4cc683597484c3dc2517919c615435a11",
        post_fetch_method = function (zip)
            unpack(zip)
            cd("wikitext-2-raw") do
                moveup("wiki.train.raw")
                moveup("wiki.valid.raw")
                moveup("wiki.test.raw")
            end
            rm("wikitext-2-raw")
        end
    ))
end
end # WikiText2Raw module

"""
    WikiText103Raw

WikiText103RawV1 corpus for character-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
module WikiText103Raw

using DataDeps

struct WikiText103RawCorpus end

dir() = datadep"WikiText-103-raw-v1"

train_files() = [joinpath(dir(), "wiki.train.raw")]
dev_files()   = [joinpath(dir(), "wiki.valid.raw")]
test_files()  = [joinpath(dir(), "wiki.test.raw")]

train_sentences(;ks...) =
    CorpusReader(WikiText103RawCorpus(), :train, train_files(), x->read_sentence(x;ks...))
dev_sentences(;ks...) =
    CorpusReader(WikiText103RawCorpus(), :dev, dev_files(), x->read_sentence(x;ks...))
test_sentences(;ks...) =
    CorpusReader(WikiText103RawCorpus(), :test, test_files(), x->read_sentence(x;ks...))

train_tokens(;ks...) =
    CorpusReader(WikiText103RawCorpus(), :train, train_files(), read_word)
dev_tokens(;ks...) =
    CorpusReader(WikiText103RawCorpus(), :dev, dev_files(), read_word)
test_tokens(;ks...) =
    CorpusReader(WikiText103RawCorpus(), :test, test_files(), read_word)

function __init__()
    moveup = x -> mv(x, joinpath("..", x))
    DataDeps.register(DataDep(
        "WikiText-103-raw-v1",
        """
        Dataset: WikiText-2 word level language modeling dataset
        Author: Stephen Merity
        License: CC-SA 3.0
        Website: https://einstein.ai/research/the-wikitext-long-term-dependency-language-modeling-dataset
        Size: 518MB (unzipped)

        Wikitext-2 word level long term dependency language modeling dataset.

        """,
        "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-103-raw-v1.zip",
        "91c00ae287f0d699e18605c84afc9e45c192bc6b7797ff8837e5474655a33794",
        post_fetch_method = function (zip)
            unpack(zip)
            cd("wikitext-103-raw") do
                moveup("wiki.train.raw")
                moveup("wiki.valid.raw")
                moveup("wiki.test.raw")
            end
            rm("wikitext-103-raw")
        end
    ))
end
end # module WikiText103Raw

end # module WikiText

# train_files(corpus) = [filename(corpus, :train)]
# dev_files(corpus)   = [filename(corpus, :valid)]
# test_files(corpus)  = [filename(corpus, :test)]

# tokentype(w::Type{Union{WikiText2,WikiText103}}) = Word()
# tokentype(w::Type{Union{WikiText2Raw,WikiText103Raw}}) = Character()

# struct WikiTextReader{T}
#     corpus::T
#     set::Symbol
#     tokens::TokenIterator
# end

# WikiTextReader(w::Union{WikiText2,WikiText103}, set::Symbol; tok=read_word) =
#     WikiTextReader(w, set, TokenIterator(open(filename(w, set)), tok))
# WikiTextReader(w::Union{WikiText2Raw,WikiText103Raw}, set::Symbol; tok=read_char) =
#     WikiTextReader(w, set, TokenIterator(open(filename(w, set)), tok))

# Base.iterate(w::WikiTextReader, state...) = iterate(w.tokens, state...)

# Base.IteratorSize(::Type{WikiTextReader{WikiText2}}) = Base.HasLength()
# Base.length(w::WikiTextReader{WikiText2}) =
#     w.set == :train ? 2051910 :
#     w.set == :valid ? 213886  :
#     w.set == :test  ? 241211  :
#     error("unknown set $(w.set)")
# Base.length(w::WikiTextReader{WikiText103}) =
#     w.set == :train ? 101425658 :
#     w.set == :valid ? 213886  :
#     w.set == :test  ? 241211  :
#     error("unknown set $(w.set)")

# Base.IteratorSize(::Type{WikiTextReader}) = Base.SizeUnknown()
# Base.IteratorEltype(::Type{WikiTextReader}) = Base.HasEltype()
# Base.eltype(::WikiTextReader{Union{WikiText2,WikiText103}}) = String
# Base.eltype(::WikiTextReader{Union{WikiText2Raw,WikiText103Raw}}) = Char

# train_tokens(w::WikiTextCorpus) = WikiTextReader(w, :train)
# dev_tokens(w::WikiTextCorpus) = WikiTextReader(w, :valid)
# test_tokens(w::WikiTextCorpus) = WikiTextReader(w, :test)

# train_sentences(w::WikiTextCorpus; k...) =
#     WikiTextReader(w, :train, tok=x->read_sentence(x; k...))
# dev_sentences(w::WikiTextCorpus; k...) =
#     WikiTextReader(w, :valid, tok=x->read_sentence(x; k...))
# test_sentences(w::WikiTextCorpus; k...) =
#     WikiTextReader(w, :test, tok=x->read_sentence(x; k...))

# function filename(corpus::WikiTextCorpus, set)
#     @assert set in [:train, :valid, :test]
#     filename = "wiki.$set.$(suffix(corpus))"
#     return joinpath(corpusdir(corpus), filename)
# end

# suffix(corpus::Union{WikiText2,WikiText103})       = "tokens"
# suffix(corpus::Union{WikiText2Raw,WikiText103Raw}) = "raw"

# corpusdir(corpus::WikiText2v1)      = datadep"WikiText-2-v1"
# corpusdir(corpus::WikiText103v1)    = datadep"WikiText-103-v1"
# corpusdir(corpus::WikiText2RawV1)   = datadep"WikiText-2-raw-v1"
# corpusdir(corpus::WikiText103RawV1) = datadep"WikiText-103-raw-v1"


abstract type WikiTextCorpus <: AbstractLanguageModelingDataset end

"""
    WikiText2v1

WikiText2v1 corpus for word-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
struct WikiText2v1 <: WikiTextCorpus end

"""
    WikiText103v1

WikiText103v1 corpus for word-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
struct WikiText103v1 <: WikiTextCorpus end

"""
    WikiText2RawV1

WikiText2RawV1 corpus for character-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
struct WikiText2RawV1 <: WikiTextCorpus end

"""
    WikiText103RawV1

WikiText103RawV1 corpus for character-level language modeling.
See https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/.
"""
struct WikiText103RawV1 <: WikiTextCorpus end

# const UNK = "<unk>"

const WikiText2 = WikiText2v1
const WikiText103 = WikiText103v1
const WikiText2Raw = WikiText2RawV1
const WikiText103Raw = WikiText103RawV1

train_files(corpus) = [filename(corpus, :train)]
dev_files(corpus)   = [filename(corpus, :valid)]
test_files(corpus)  = [filename(corpus, :test)]

tokentype(w::Type{Union{WikiText2,WikiText103}}) = Word()
tokentype(w::Type{Union{WikiText2Raw,WikiText103Raw}}) = Character()

struct WikiTextReader{T}
    corpus::T
    set::Symbol
    tokens::TokenIterator
end

WikiTextReader(w::Union{WikiText2,WikiText103}, set::Symbol) =
    WikiTextReader(w, set, TokenIterator(open(filename(w, set)), read_word))
WikiTextReader(w::Union{WikiText2Raw,WikiText103Raw}, set::Symbol) =
    WikiTextReader(w, set, TokenIterator(open(filename(w, set)), read_char))

Base.iterate(w::WikiTextReader, state...) = iterate(w.tokens, state...)

Base.IteratorSize(::Type{WikiTextReader{WikiText2}}) = Base.HasLength()
length(w::WikiTextReader{WikiText2}) =
    w.set == :train ? 2051910 :
    w.set == :valid ? 213886  :
    w.set == :test  ? 241211  :
    error("unknown set $(w.set)")
length(w::WikiTextReader{WikiText103}) =
    w.set == :train ? 101425658 :
    w.set == :valid ? 213886  :
    w.set == :test  ? 241211  :
    error("unknown set $(w.set)")

Base.IteratorSize(::Type{WikiTextReader}) = Base.SizeUnknown()
Base.IteratorEltype(::Type{WikiTextReader}) = Base.HasEltype()
Base.eltype(::WikiTextReader{Union{WikiText2,WikiText103}}) = String
Base.eltype(::WikiTextReader{Union{WikiText2Raw,WikiText103Raw}}) = Char

train_tokens(w::WikiTextCorpus) = WikiTextReader(w, :train)
dev_tokens(w::WikiTextCorpus) = WikiTextReader(w, :valid)
test_tokens(w::WikiTextCorpus) = WikiTextReader(w, :test)

function filename(corpus::WikiTextCorpus, set)
    @assert set in [:train, :valid, :test]
    filename = "wiki.$set.$(suffix(corpus))"
    return joinpath(corpusdir(corpus), filename)
end

suffix(corpus::Union{WikiText2,WikiText103})       = "tokens"
suffix(corpus::Union{WikiText2Raw,WikiText103Raw}) = "raw"

corpusdir(corpus::WikiText2v1)      = datadep"WikiText-2-v1"
corpusdir(corpus::WikiText103v1)    = datadep"WikiText-103-v1"
corpusdir(corpus::WikiText2RawV1)   = datadep"WikiText-2-raw-v1"
corpusdir(corpus::WikiText103RawV1) = datadep"WikiText-103-raw-v1"

function register_wikitext()
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
        end
    ))

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

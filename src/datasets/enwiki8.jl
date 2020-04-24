"""
    HutterPrize

todo
"""
module HutterPrize

using DataDeps
import ...AbstractLanguageModelingDataset, ...TokenIterator, ...read_byte
struct HutterPrizeDataset <: AbstractLanguageModelingDataset end

file() = datadep"enwiki8"

train_tokens() = train_tokens(HutterPrizeDataset())
dev_tokens()   = dev_tokens(HutterPrizeDataset())
test_tokens()  = test_tokens(HutterPrizeDataset())

train_tokens(corpus::HutterPrizeDataset) =
    read_tokens(corpus, train=true, dev=false, test=false)
dev_tokens(corpus::HutterPrizeDataset) =
    read_tokens(corpus, train=false, dev=true, test=false)
test_tokens(corpus::HutterPrizeDataset) =
    read_tokens(corpus, train=false, dev=false, test=true)

function read_tokens(HutterPrizeDataset; train=true, dev=true, test=true)
    tokens = TokenIterator(open(file()), read_byte)
    return HutterPrizeTokens(tokens, train, dev, test)
end

struct HutterPrizeTokens
    tokens::TokenIterator
    train::Bool
    dev::Bool
    test::Bool
end

function Base.length(corpus::HutterPrizeTokens)
    len = 0
    corpus.train && (len += 90_000_000)
    corpus.dev   && (len += 5_000_000)
    corpus.test  && (len += 5_000_000)
    return len
end

Base.IteratorSize(::Type{HutterPrizeTokens}) = Base.HasLength()
Base.IteratorEltype(::Type{HutterPrizeTokens}) = Base.HasEltype()
Base.eltype(::HutterPrizeTokens) = Char

function Base.iterate(corpus::HutterPrizeTokens, state=1)
    next = iterate(corpus.tokens, state)
    if next !== nothing
        if 1 <= state <= 90_000_000 && !corpus.train
            read(corpus.tokens.io, 90_000_000 - state)
            return iterate(corpus, 90_000_001)
        elseif 90_000_000 < state <= 95_000_000 && !corpus.dev
            read(corpus.tokens.io, 95_000_000 - state)
            return iterate(corpus, 95_000_001)
        elseif 95_000_000 < state <= 100_000_000 && !corpus.test
            return nothing
        else
            return next
        end
    end
end

function __init__()
    DataDeps.register(DataDep(
        "enwiki8",
        """
        todo
        """,
        "http://mattmahoney.net/dc/enwik8.zip",
        "547994d9980ebed1288380d652999f38a14fe291a6247c157c3d33d4932534bc",
        post_fetch_method=unpack
    ))
end

end # module

function read_word(io)
    buf = IOBuffer()
    c = read_char(io)
    while isspace(c) && !eof(io)
        c = read_char(io)
    end
    while !isspace(c) && !eof(io)
        write(buf, c)
        c = read_char(io)
    end
    while !eof(io) && isspace(Char(Iterators.peek(io)))
        c = read_char(io)
    end
    return String(take!(buf))
end
read_byte(io) = Char(read(io, 1)[1])
read_char(io) = read(io, Char)

function read_sentence(io;
                       tokenize=x -> split(strip(x), r"\s+", keepempty=false),
                       pad=false, pad_left=true, pad_right=true, bos="<S>", eos="</S>")
    line = readline(io)
    while isempty(strip(line))
        line = readline(io)
    end
    tokens = tokenize(line)
    if pad
        return [bos; tokens; eos]
    else
        pad_left  && (tokens = [bos ; tokens])
        pad_right && (tokens = [tokens ; eos])
        return tokens
    end
end

struct TokenIterator{F}
    io::IO
    tokenize::F
end

(iter::TokenIterator)() = iter.tokenize(iter.io)

Base.eltype(::TokenIterator{read_sentence}) = Vector{String}
Base.eltype(::TokenIterator{read_char}) = Char
Base.eltype(::TokenIterator{read_byte}) = Char
Base.eltype(::TokenIterator{read_word}) = String

function read_token(iter::TokenIterator)
    if eof(iter.io)
        close(iter.io)
        return nothing
    else
        return iter.tokenize(iter.io)
    end
end

function Base.iterate(iter::TokenIterator, state=1)
    token = read_token(iter)
    return token === nothing ? nothing : (token, state + 1)
end

mutable struct MultiFileTokenIterator
    files::Vector{String}
    i::Int
    t::TokenIterator
end
function MultiFileTokenIterator(files, tokenize)
    tokens = TokenIterator(open(first(files)), tokenize)
    return MultiFileTokenIterator(collect(files), 1, tokens)
end

function Base.iterate(t::MultiFileTokenIterator)
    return iterate(t.t)
end
function Base.iterate(t::MultiFileTokenIterator, state)
    next = iterate(t.t, state)
    if next === nothing
        close(t.t.io)
        if t.i < length(t.files)
            t.i += 1
            t.t = TokenIterator(open(t.files[t.i]), t.t.tokenize)
            return iterate(t.t)
        end
    else
        return next        
    end
end

struct CorpusReader{C<:AbstractLanguageModelingDataset,S,T<:AbstractTokenType}
    corpus::C
    reader::MultiFileTokenIterator
end
CorpusReader(corpus, set, files, tokenize, T) =
    CorpusReader{typeof(corpus),set,T}(corpus, MultiFileTokenIterator(files, tokenize))

Base.eltype(::CorpusReader{C,S,Character}) where {C,S} = Char
Base.eltype(::CorpusReader{C,S,Word}) where {C,S}      = String
Base.eltype(::CorpusReader{C,S,Sentence}) where {C,S}  = Vector{String}

Base.iterate(c::CorpusReader, state...) = iterate(c.reader, state...)

Base.IteratorEltype(::Type{CorpusReader}) = Base.EltypeUnknown()
Base.IteratorEltype(::Type{<:CorpusReader{C,S,Character}}) where {C,S} = Base.HasEltype()
Base.IteratorEltype(::Type{<:CorpusReader{C,S,Word}}) where {C,S}      = Base.HasEltype()
Base.IteratorEltype(::Type{<:CorpusReader{C,S,Sentence}}) where {C,S}  = Base.HasEltype()

Base.IteratorSize(::Type{CorpusReader}) = Base.SizeUnknown()

# Base.show(io::IO, c::CorpusReader{C,S,T}) where {C,S,T} =
#     print(io, "Language Modeling Dataset: $C")


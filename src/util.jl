function read_word(io)
    b = IOBuffer()
    c = read_char(io)
    while isspace(c)
        c = read_char(io)
    end
    while !isspace(c)
        write(b, c)
        c = read_char(io)
    end
    while isspace(Char(Iterators.peek(io)))
        c = read_char(io)
    end
    return String(take!(b))
end
read_byte(io) = Char(read(io, 1)[1])
read_char(io) = read(io, Char)

function read_sentence(io;
                       tokenize=x -> split(strip(x), r"\s+", keepempty=false),
                       pad=true, bos="<BOS>", eos="<EOS>")
    line = readline(io)
    tokens = tokenize(line)
    if pad
        return [bos ; tokens ; eos]
    else
        return tokens
    end
end

struct TokenIterator{F}
    io::IO
    tokenize::F
end

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



#!/bin/bash

julia --project=. -e 'using Pkg; Pkg.instantiate()'

# build docs
julia --color=yes --project=. make.jl

# "deploy"
cd build
python3 -m http.server --bind localhost

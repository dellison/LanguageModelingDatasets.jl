using Documenter
using LanguageModelingDatasets

DocMeta.setdocmeta!(LanguageModelingDatasets,
                    :DocTestSetup, :(using LanguageModelingDatasets); recursive=true)

makedocs(
    sitename = "LanguageModelingDatasets.jl",
    format = Documenter.HTML(),
    modules = [LanguageModelingDatasets],
    pages = ["Home" => "index.md"],
    doctest = true)

deploydocs(repo = "github.com/dellison/LanguageModelingDatasets.jl.git")

using LanguageModelingDatasets, Test

@testset "LanguageModelingDatasets.jl" begin
    @test 1 == 1

    @testset "Billion Word Benchmark" begin
    end

    @testset "WikiText" begin
    end

    @testset "enwiki8" begin
        corpus = enwiki8()
        @test length(train_tokens(corpus)) == 90_000_000
        @test length(dev_tokens(corpus)) == 5_000_000
        @test length(test_tokens(corpus)) == 5_000_000
    end
end

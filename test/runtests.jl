using LanguageModelingDatasets, Test

@testset "LanguageModelingDatasets.jl" begin
    @test 1 == 1

    function howmany(xs)
        c = 0
        for x in xs
            c += 1
        end
        return c
    end

    @testset "Billion Word Benchmark" begin
        corpus = BillionWordBenchmark()
        # @test collect(Iterators.take(train_tokens(corpus), 6)) ==
        #     ["The", "U.S.", "Centers", "for", "Disease", "Control"]

        tokens = 829_250_940
        # n_train = howmany(train_tokens(corpus))
        # n_test = howmany(test_tokens(corpus))
        # @show n_train n_test
        # @test n_train + n_test == tokens
        # @show howmany(Iterators.flatten(train_sentences(corpus)))
        # @show howmany(Iterators.flatten(test_sentences(corpus)))
    end

    @testset "WikiText" begin
        for corpus in [WikiText2(), WikiText103(), WikiText2Raw(), WikiText103Raw()]
            @test isfile(train_files(corpus)[1])
            @test isfile(dev_files(corpus)[1])
            @test isfile(test_files(corpus)[1])
        end
    end

    @testset "enwiki8" begin
        corpus = enwiki8()
        @test length(train_tokens(corpus)) == 90_000_000
        @test length(dev_tokens(corpus)) == 5_000_000
        @test length(test_tokens(corpus)) == 5_000_000
    end
end

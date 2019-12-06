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
        using LanguageModelingDatasets: BillionWordBenchmark
        train_tokens = BillionWordBenchmark.train_tokens()
        @test collect(Iterators.take(train_tokens, 6)) ==
            ["The", "U.S.", "Centers", "for", "Disease", "Control"]

        @test first(BillionWordBenchmark.train_sentences()) ==
            split("<S> The U.S. Centers for Disease Control and Prevention initially advised school systems to close if outbreaks occurred , then reversed itself , saying the apparent mildness of the virus meant most schools and day care centers should stay open , even if they had confirmed cases of swine flu . </S>")
        tokens = 829_250_940
        # n_train = howmany(train_tokens(corpus))
        # n_test = howmany(test_tokens(corpus))
        # @show n_train n_test
        # @test n_train + n_test == tokens
        # @show howmany(Iterators.flatten(train_sentences(corpus)))
        # @show howmany(Iterators.flatten(test_sentences(corpus)))
    end

    @testset "WikiText" begin
        using LanguageModelingDatasets: WikiText2, WikiText103, WikiText2Raw, WikiText103Raw
        for WT in [WikiText2, WikiText103, WikiText2Raw, WikiText103Raw]
            @test isfile(WT.train_files()[1])
            @test isfile(WT.dev_files()[1])
            @test isfile(WT.test_files()[1])
        end
    end

    @testset "enwiki8" begin
        using LanguageModelingDatasets: HutterPrize
        @test length(HutterPrize.train_tokens()) == 90_000_000
        @test length(HutterPrize.dev_tokens()) == 5_000_000
        @test length(HutterPrize.test_tokens()) == 5_000_000
    end
end

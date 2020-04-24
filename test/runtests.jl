using LanguageModelingDatasets, Test

@testset "LanguageModelingDatasets.jl" begin
    # include("test_billionwords.jl")

    @testset "WikiText" begin
        for WT in (WikiText2, WikiText103, WikiText2Raw, WikiText103Raw)
            @test isfile(WT.train_files()[1])
            @test isfile(WT.dev_files()[1])
            @test isfile(WT.test_files()[1])
        end
    end

    @testset "Hutter Prize/enwiki8" begin
        @test length(HutterPrize.train_tokens()) == 90_000_000
        @test length(HutterPrize.dev_tokens()) == 5_000_000
        @test length(HutterPrize.test_tokens()) == 5_000_000
    end
end

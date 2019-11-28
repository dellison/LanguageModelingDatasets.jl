struct HutterPrize <: AbstractLanguageModelingDataset end

const enwiki8 = HutterPrize

train_files(::HutterPrize) = enwiki8_file()
dev_files(::HutterPrize)   = enwiki8_file()
test_files(::HutterPrize)  = enwiki8_file()

enwiki8_file() = joinpath(datadep"enwiki8", "enwiki8", "enwiki8")

function register_enwiki8()
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

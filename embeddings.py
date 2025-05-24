import gensim.downloader as api

model = api.load("glove-wiki-gigaword-50")

# pizza - italy = france - ?
result = model.most_similar(positive=["pizza", "korea"], negative=["italy"], topn=5)

for word, score in result:
    print(f"{word}: {score:.4f}")

vector = model["carthage"]
print(vector)

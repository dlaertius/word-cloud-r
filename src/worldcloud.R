#Based on tutorial avaliable here: https://www.r-bloggers.com/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know/
# Diogenes, 03-25-2017

#Load needed libraries. If you will use portuguese phrases, some steps isn't necessary cause won't work to this lang.
library("tm")
library("NLP")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

# Read the text file from internet, this is on tutorial
filePath <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
text <- readLines(filePath)

#Load the file with phreases in a text var.
#text <- readLines(file.choose())

#Load data as a corpus.
#Corpus is a list of documents, in this case is only one document.
docs <- Corpus(VectorSource(text))

#I don't exaclty whats this command do.
#Inspect the content of the doc.
inspect(doc)

#Replace symbols, removing unnecessary.
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case.
docs <- tm_map(docs, content_transformer(tolower))

# Remove numbers.
docs <- tm_map(docs, removeNumbers)

# Remove english common stopwords.
docs <- tm_map(docs, removeWords, stopwords("english"))

# specify your stopwords as a character vector - I didn't use here.
#docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))

# Remove punctuations.
docs <- tm_map(docs, removePunctuation)

#Delete extra spaces.
docs <- tm_map(docs, stripWhitespace)

#Stemming
docs <- tm_map(docs, stemDocument)

#----------------------- Start from here it's capture the frequency of words in doc.

#Matrix is a table containing all the frequencies of the words.
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)

#How much words will have in cloud.
count_words <- 10

head(d, count_words)

#----------------- Now we will generate our w.cloud

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words = 200, random.order = FALSE, rot.per = 0.35, colors = brewer.pal(8,"Dark2"))





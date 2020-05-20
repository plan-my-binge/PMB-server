rm -r ~/datafiles
mkdir -p datafiles
cd datafiles

curl https://datasets.imdbws.com/title.basics.tsv.gz -o title.basics.tsv.gz
curl https://datasets.imdbws.com/title.episode.tsv.gz -o title.episode.tsv.gz
curl https://datasets.imdbws.com/title.ratings.tsv.gz -o title.ratings.tsv.gz

gzip -d title.basics.tsv.gz
gzip -d title.episode.tsv.gz
gzip -d title.ratings.tsv.gz
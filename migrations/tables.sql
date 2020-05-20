create table IF NOT EXISTS title_basics
(
    tconst         text primary key,
    titletype      text,
    primarytitle   text,
    originaltitle  text,
    isadult        integer,
    startyear      integer,
    endyear        integer,
    runtimeminutes integer,
    genres         text
);

create table IF NOT EXISTS title_episode
(
    tconst        text primary key references title_basics (tconst),
    parenttconst  text,
    seasonnumber  integer,
    episodenumber integer
);

create table IF NOT EXISTS title_ratings
(
    tconst        text primary key references title_basics (tconst),
    averagerating numeric,
    numvotes      integer
);

TRUNCATE title_basics;
TRUNCATE title_episode;
TRUNCATE title_ratings;


copy title_basics (
                   tconst,
                   titletype,
                   primarytitle,
                   originaltitle,
                   isadult,
                   startyear,
                   endyear,
                   runtimeminutes,
                   genres)
    from '~/datafiles/title.basics.tsv'
    with delimiter e'\t'
    quote '|'
    null as '\N'
    csv header;

copy title_episode (
                    tconst,
                    parenttconst,
                    seasonnumber,
                    episodenumber)
    from '~/datafiles/title.episode.tsv'
    with delimiter e'\t'
    quote '|'
    null as '\N'
    csv header;

copy title_ratings (
                    tconst,
                    averagerating,
                    numvotes)
    from '~/datafiles/title.ratings.tsv'
    with delimiter e'\t'
    quote '|'
    null as '\N'
    csv header;


create TABLE internal_id_mapping (
    pmb_id integer,
    tconst text
);

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


create table title_posters
(
    tconst          text not null
        constraint title_posters_pkey
            primary key,
    landscapeposter text,
    portraitposter  text
);

create table title_posters_bk
(
    tconst          text not null
        constraint title_posters_bk_pkey
            primary key,
    landscapeposter text,
    portraitposter  text
);

insert into title_posters_bk
select * from title_posters tp;

truncate title_posters ;
TRUNCATE title_basics  CASCADE;

\copy title_basics (tconst, titletype, primarytitle, originaltitle, isadult, startyear, endyear, runtimeminutes, genres) from '~/datafiles/title.basics.tsv' with delimiter e'\t' quote '|' null as '\N' csv header;
\copy title_episode ( tconst, parenttconst, seasonnumber, episodenumber) from '~/datafiles/title.episode.tsv' with delimiter e'\t' quote '|' null as '\N' csv header;
\copy title_ratings ( tconst, averagerating, numvotes) from '~/datafiles/title.ratings.tsv' with delimiter e'\t' quote '|' null as '\N' csv header;


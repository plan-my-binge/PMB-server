

create view series_metrics as
select seriesId,
       t.primarytitle,
       t.startyear,
       t.endyear,
       t.genres,
       seasonnumber,
       numberOfEpisodes,
       seasonRunTime,
       tr.averagerating,
       tp.landscapeposter,
       tp.portraitposter,
       t.runtimeminutes as perEpisodeRuntime,
       t.id as pmb_id
from (
         select tb.tconst              seriesId,
                seasonnumber,
                count(episodenumber)   numberOfEpisodes,
                sum(tb.runtimeminutes) seasonRunTime
         from title_episode te
                  join title_basics tb on te.parenttconst = tb.tconst
         where te.seasonnumber is not null
         group by seasonnumber, tb.tconst) episodes
         join title_basics t
              on t.tconst = seriesId
         join title_ratings tr
              on t.tconst = tr.tconst
         join title_posters tp
              on t.tconst = tp.tconst
order by seriesId, seasonnumber
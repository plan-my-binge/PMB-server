DROP VIEW series_metrics;

create view series_metrics as
select seriesId,
       show_basic.primarytitle,
       show_basic.startyear,
       show_basic.endyear,
       seasonStartYear,
       show_basic.genres,
       seasonnumber,
       numberOfEpisodes,
       seasonRunTime,
       show_rating.averagerating,
       show_poster.landscapeposter,
       show_poster.portraitposter,
       show_basic.runtimeminutes as perEpisodeRuntime,
       map.pmb_id                as pmb_id
from (
         select show_basic.tconst              seriesId,
                seasonnumber,
                count(episodenumber)           numberOfEpisodes,
                sum(show_basic.runtimeminutes) seasonRunTime,
                min(episode_basic.startyear)   seasonStartYear
         from title_episode episode
                  join title_basics show_basic on episode.parenttconst = show_basic.tconst
                  join title_basics episode_basic on episode.tconst = episode_basic.tconst
         where episode.seasonnumber is not null
         group by seasonnumber, show_basic.tconst) episodes
         join title_basics show_basic
              on show_basic.tconst = seriesId
         join internal_id_mapping map
              on show_basic.tconst = map.tconst
         join title_ratings show_rating
              on show_basic.tconst = show_rating.tconst
         left join title_posters_bk show_poster
              on show_basic.tconst = show_poster.tconst
order by seriesId, seasonnumber

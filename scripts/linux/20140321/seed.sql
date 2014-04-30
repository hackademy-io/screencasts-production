-- create table
drop table if exists rankings;
create table rankings (
  nick  varchar(40) not null,
  score integer     not null
);

-- insert fake data
insert into rankings
select ('user' || (t.id::text)) as nick, (random() * 1000000)::integer
from (select * from generate_series(1,1000000) as id)
as t;

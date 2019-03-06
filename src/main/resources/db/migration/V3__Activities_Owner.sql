create table "user"
(
  id bigint not null primary key,
  username varchar(500),
  date_created timestamp default now() not null
);

create unique index user_username_uindex
  on "user" (username);

alter table activity
  add owner_id BIGINT;

alter table activity
  add constraint activity_user_id_fk
    foreign key (owner_id) references "user"
      on delete cascade;
create table registration
(
	id bigint not null
		constraint pk_registration
			primary key,
	registration_date timestamp with time zone default now() not null,
	user_id bigint not null
		constraint fk_registration_user
			references "user"
				on delete cascade,
	activity_id bigint not null
		constraint fk_registration_activity
			references activity
				on delete cascade
);

create index fki_registration_user
	on registration (user_id);

create index fki_registration_activity
	on registration (activity_id);


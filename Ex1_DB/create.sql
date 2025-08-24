create table oscarEvent(
	year integer check (year > 0) primary key
);

create table contentRating(
	type varchar(100) primary key
);

create table film(
	id varchar(100) primary key,
	duration integer check (duration>0),
	releaseYear integer check (releaseYear > 0),
	title varchar(100) not null,
	producer varchar(100) not null,
	IMDBRating numeric check (IMDBRating >= 0 and IMDBRating <= 10),
	IMDBVotes integer check (IMDBVotes >= 0),
	contentRatingType varchar(100),
	oscarYear integer,
	foreign key(contentRatingType) references contentRating(type),
	foreign key(oscarYear) references oscarEvent(year)
);



create table winners(
	oscarYear integer primary key,
	filmId varchar(100),
	foreign key(filmId) references film(id),
	foreign key(oscarYear) references oscarEvent(year)
);

create table director(
	name varchar(100) primary key
);

create table directedBy(
	filmId varchar(100),
	directorName varchar(100),
	primary key(filmId, directorName),
	foreign key(filmId) references film(id),
	foreign key(directorName) references director(name)
);

create table author(
	name varchar(100) primary key
);

create table writtenBy(
	filmId varchar(100),
	authorName varchar(100),
	primary key(filmId, authorName),
	foreign key(filmId) references film(id),
	foreign key(authorName) references author(name)
	
);

create table actor(
	name varchar(100) primary key
);

create table actedIn(
	filmId varchar(100),
	actorName varchar(100),
	primary key(filmId, actorName),
	foreign key(filmId) references film(id),
	foreign key(actorName) references actor(name)
	
);

create table genre(
	name varchar(100) primary key
);

create table belongsTo(
	filmId varchar(100),
	genreName varchar(100),
	primary key(filmId, genreName),
	foreign key(filmId) references film(id),
	foreign key(genreName) references genre(name)
);



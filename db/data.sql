create table droits(
    id SERIAL primary key,
    name varchar(255) not null
);
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table utilisateur(
    id_utilisateur SERIAL primary key,
    access_token   uuid default uuid_generate_v4() not null unique,
    username varchar(255) not null,
    password varchar(255) not null,
    email varchar(255) not null,
    nom varchar(255) not null,
    prenom varchar(255) not null,
    date_naissance date not null,
    telephone varchar(255) not null,
    adresse varchar(255) not null,
    rights int4 not null,
    foreign key(rights) references droits(id)
);

insert into droits( name) values( 'admin');
insert into droits( name) values( 'user');

insert into utilisateur(username, password, email, nom, prenom,
                        date_naissance, telephone, adresse, rights) values('admin', 'admin','admin@admin.com', 'admin', 'admin', '2000-01-01', '0612345678', 'admin', 1);

insert into utilisateur(username, password, email, nom, prenom,
                        date_naissance, telephone, adresse, rights) values('user', 'user','user@user.com', 'user', 'user', '2000-01-01', '0612345678', 'user', 2);

create table positionGPS(
    id SERIAL primary key,
    latitude float8 not null,
    longitude float8 not null,
    altitude float8,
    distance float8 not null,
    belongsTo int8 not null,
    dateCreated Date not null,
    foreign key(belongsTo) references utilisateur(id_utilisateur)
);


create table useraccount (
   userid varchar(10) primary key,
   password varchar(15),
   username varchar(20),
   phoneno varchar(20),
   postcode varchar(7),
   address varchar(30),
   email varchar(50),
   birthday datetime
);

CREATE TABLE sale (
	saleid int PRIMARY KEY,
	userid varchar(10) NOT NULL,
	saledate datetime,
	foreign key(userid) references useraccount(userid)
);
CREATE TABLE saleitem (
	saleid int ,
	seq int ,
	itemid int NOT NULL,
	quantity int,
	PRIMARY KEY (saleid, seq),
	foreign key(saleid) references sale(saleid),
	foreign key(itemid) references item(id)
);

CREATE TABLE board (
	num int primary key,
	writer varchar(30),
	pass varchar(20),
	title varchar(100),
	content varchar(2000),
	file1 varchar(200),
	boardid varchar(2),
	regdate datetime,
	readcnt int(10),
	grp int,
	grplevel int(3),
	grpstep int(5)
)

select * from useraccount
select * from sale
select * from saleitem
select * from board
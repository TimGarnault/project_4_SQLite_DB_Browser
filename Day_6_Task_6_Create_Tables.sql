CREATE TABLE Scientists (
  SSN int,
  Name Char(30) not null,
  Primary Key (SSN)
);

CREATE TABLE Projects (
  Code Char(4),
  Name Char(50) not null,
  Primary Key (Code)
);
	
CREATE TABLE AssignedTo (
  Scientist int not null,
  Project char(4) not null,
  Hours int,
  Primary Key (Scientist, Project)
);

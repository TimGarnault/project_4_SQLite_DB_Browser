INSERT INTO Scientists(SSN,Name) 
VALUES(123234877,'Michael Rogers'),
(152934485,'Anand Manikutty'),
(222364883, 'Carol Smith'),
(326587417,'Joe Stevens'),
(332154719,'Mary-Anne Foster'),	
(332569843,'George ODonnell'),
(546523478,'John Doe'),
(631231482,'David Smith'),
(654873219,'Zacary Efron'),
(745685214,'Eric Goldsmith'),
(845657245,'Elizabeth Doe'),
(845657246,'Kumar Swamy');

INSERT INTO Projects ( Code,Name)
VALUES ('AeH1','Winds: Studying Bernoullis Principle'),
('AeH2','Aerodynamics and Bridge Design'),
('AeH3','Aerodynamics and Gas Mileage'),
('AeH4','Aerodynamics and Ice Hockey'),
('AeH5','Aerodynamics of a Football'),
('AeH6','Aerodynamics of Air Hockey'),
('Ast1','A Matter of Time'),
('Ast2','A Puzzling Parallax'),
('Ast3','Build Your Own Telescope'),
('Bte1','Juicy: Extracting Apple Juice with Pectinase'),
('Bte2','A Magnetic Primer Designer'),
('Bte3','Bacterial Transformation Efficiency'),
('Che1','A Silver-Cleaning Battery'),
('Che2','A Soluble Separation Solution');

INSERT INTO AssignedTo ( Scientist, Project, Hours)
VALUES (123234877,'AeH1', 156),
(152934485,'AeH3',189),
(222364883,'Ast3', 256),	   
(326587417,'Ast3', 789),
(332154719,'Bte1', 98),
(546523478,'Che1',89),
(631231482,'Ast3',112),
(654873219,'Che1', 299),
(745685214,'AeH3', 6546),
(845657245,'Ast1', 321),
(845657246,'Ast2', 9684),
(332569843,'AeH4', 321);

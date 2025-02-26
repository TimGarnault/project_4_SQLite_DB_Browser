CREATE TABLE Employee (
  EmployeeID INTEGER,
  Name VARCHAR(255) NOT NULL,
  Position VARCHAR(255) NOT NULL,
  Salary REAL NOT NULL,
  Remarks VARCHAR(255),
  PRIMARY KEY (EmployeeID)
); 

CREATE TABLE Planet (
  PlanetID INTEGER,
  Name VARCHAR(255) NOT NULL,
  Coordinates REAL NOT NULL,
  PRIMARY KEY (PlanetID)
); 

CREATE TABLE Shipment (
  ShipmentID INTEGER,
  Date DATE,
  Manager INTEGER NOT NULL,
  Planet INTEGER NOT NULL,
  PRIMARY KEY (ShipmentID)
);

CREATE TABLE Has_Clearance (
  Employee INTEGER NOT NULL,
  Planet INTEGER NOT NULL,
  Level INTEGER NOT NULL,
  PRIMARY KEY(Employee, Planet)
); 

CREATE TABLE Client (
  AccountNumber INTEGER,
  Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (AccountNumber)
);
  
CREATE TABLE Package (
  Shipment INTEGER NOT NULL,
  PackageNumber INTEGER NOT NULL,
  Contents VARCHAR(255) NOT NULL,
  Weight REAL NOT NULL,
  Sender INTEGER NOT NULL,
  Recipient INTEGER NOT NULL,
  PRIMARY KEY(Shipment, PackageNumber)
  );
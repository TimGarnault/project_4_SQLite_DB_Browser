Questions
-- 8.1 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
WITH ProcedureWithPhysicianCertified AS (
SELECT Undergoes.Patient, Undergoes.Physician, Undergoes.Procedure
FROM Undergoes
JOIN Trained_In
ON Undergoes.Procedure = Trained_In.Treatment
AND Undergoes.Physician = Trained_In.Physician)
SELECT Physician.Name
FROM Undergoes
JOIN Physician
ON Physician.EmployeeID = Undergoes.Physician
WHERE (Undergoes.Patient, Undergoes.Physician, Undergoes.Procedure) NOT IN (
SELECT Patient, Physician, Procedure
FROM ProcedureWithPhysicianCertified);

-- 8.2 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.
WITH ProcedureWithPhysicianCertified AS (
SELECT Undergoes.Patient, Undergoes.Physician, Undergoes.Procedure
FROM Undergoes
JOIN Trained_In
ON Undergoes.Procedure = Trained_In.Treatment
AND Undergoes.Physician = Trained_In.Physician)
SELECT Physician.Name AS PysicianName, Procedures.Name AS ProcedureName, 
Undergoes.Date AS ProcedureDate, Patient.Name AS PatientName
FROM Undergoes
JOIN Physician
ON Physician.EmployeeID = Undergoes.Physician
JOIN Procedures
ON Procedures.Code=Undergoes.Procedure
JOIN Patient
ON Patient.SSN=Undergoes.Patient
WHERE (Undergoes.Patient, Undergoes.Physician, Undergoes.Procedure) NOT IN (
SELECT Patient, Physician, Procedure
FROM ProcedureWithPhysicianCertified);

-- 8.3 Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).
WITH ProcedureWithPhysicianCertified AS (
SELECT Undergoes.Patient, Undergoes.Physician, Undergoes.Procedure, Undergoes.Date, Trained_In.CertificationExpires
FROM Undergoes
JOIN Trained_In
ON Undergoes.Procedure = Trained_In.Treatment
AND Undergoes.Physician = Trained_In.Physician)
SELECT Physician.Name AS PysicianName
FROM Undergoes
JOIN Physician
On Physician.EmployeeID = Undergoes.Physician
WHERE Undergoes.Date > (SELECT CertificationExpires FROM ProcedureWithPhysicianCertified)

-- 8.4 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on, and date when the certification expired.
WITH ProcedureWithPhysicianCertified AS (
SELECT Undergoes.Patient, Undergoes.Physician, Undergoes.Procedure, Undergoes.Date, Trained_In.CertificationExpires
FROM Undergoes
JOIN Trained_In
ON Undergoes.Procedure = Trained_In.Treatment
AND Undergoes.Physician = Trained_In.Physician)
SELECT Physician.Name AS PysicianName, Procedures.Name AS ProcedureName, Undergoes.Date AS ProcedureDate, 
Patient.Name AS PatientName, Trained_In.CertificationExpires
FROM Undergoes
JOIN Physician
	ON Physician.EmployeeID = Undergoes.Physician
JOIN Procedures
	ON Procedures.Code=Undergoes.Procedure
JOIN Patient
	ON Patient.SSN=Undergoes.Patient
JOIN Trained_In
	ON Undergoes.Procedure = Trained_In.Treatment
WHERE Undergoes.Date > (SELECT CertificationExpires FROM ProcedureWithPhysicianCertified)

-- 8.5 Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.
--Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.

WITH DiffPhysByPat AS(SELECT 
	Appointment.Patient AS PatientName, 
	Appointment.Physician AS PhysicianName,
	first_value(Appointment.Physician) OVER(PARTITION BY Appointment.Patient ORDER BY Appointment.Start) AS PhysicianPrimaryCareID,
	last_value(Appointment.Physician) OVER(PARTITION BY Appointment.Patient ORDER BY Appointment.Start) AS PhysicianLastCareID,
	Physician.Name AS PhysicianLastCareName
FROM Appointment
JOIN Physician
	ON Physician.EmployeeID=Appointment.Physician)
SELECT
	Patient.Name AS PatientName,
	DiffPhysByPat.PhysicianLastCareName AS PhysicianName,
	Nurse.Name AS NurseName,
	Appointment.Start AS AppointmentStartTime,
	Appointment.End AS AppointmentEndTime,
	Appointment.ExaminationRoom,
	Physician.Name AS PhysicianPrimaryCareName
FROM DiffPhysByPat
JOIN Appointment 
	ON DiffPhysByPat.PatientName=Appointment.Patient
JOIN Patient
	ON Patient.SSN=Appointment.Patient
JOIN Physician
	ON Physician.EmployeeID=DiffPhysByPat.PhysicianPrimaryCareID
LEFT JOIN Nurse
	ON Nurse.EmployeeID=Appointment.PrepNurse
WHERE DiffPhysByPat.PhysicianPrimaryCareID != DiffPhysByPat.PhysicianLastCareID
AND DiffPhysByPat.PhysicianPrimaryCareID != Appointment.Physician
GROUP BY Appointment.Start
ORDER BY Appointment.Patient ASC 

-- 8.6 The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. 
--There are no constraints in force to prevent inconsistencies between these two tables. 
--More specifically, the Undergoes table may include a row where the patient ID does not match 
--the one we would obtain from the Stay table through the Undergoes Stay foreign key. 
--Select all rows from Undergoes that exhibit this inconsistency.

-- UndergoesTable does not have the patient ID = 100000003
-- UndergoesTable has an inconsistent StayID for the patient ID 100000001
WITH MisMatchPatientIdStayId AS (SELECT DISTINCT
	Stay.Patient AS Stay_PatientID, 
	Undergoes.Patient AS Undergoes_PatientID,
	Stay.StayID AS Stay_StayID, 
	Undergoes.Stay AS Undergoes_StayID
FROM Stay
LEFT JOIN Undergoes
	ON Stay.Patient=Undergoes.Patient)
SELECT 
	Stay.Patient AS StayTable_PatientID,
	MisMatchPatientIdStayId.Undergoes_PatientID AS UndergoesTable_PatientID,
	Stay.StayID AS StayTable_StayID,
	MisMatchPatientIdStayId.Undergoes_StayID AS UndergoesTable_StayID
FROM Stay
JOIN MisMatchPatientIdStayId
	On Stay.Patient = MisMatchPatientIdStayId.Stay_PatientID
WHERE MisMatchPatientIdStayId.Undergoes_StayID != MisMatchPatientIdStayId.Stay_StayID
	OR MisMatchPatientIdStayId.Undergoes_PatientID IS NULL 
	OR MisMatchPatientIdStayId.Undergoes_PatientID != MisMatchPatientIdStayId.Stay_PatientID
	
-- above query does not include : Undergoes Date are not always in the range of the start end dates in the table Stay 
SELECT *
FROM Stay
LEFT JOIN Undergoes
ON Stay.Patient=Undergoes.Patient
WHERE Undergoes.Date NOT BETWEEN Stay.Start AND Stay.End

-- 8.7 Obtain the names of all the nurses who have ever been on call for room 123.
SELECT 
	Nurse.Name
FROM On_Call
JOIN Room
	ON On_Call.BlockCode=Room.BlockCode
AND On_Call.BlockFloor=Room.BlockFloor
JOIN Nurse
	ON Nurse.EmployeeID = On_Call.Nurse
WHERE Room.Number=123

-- 8.8 The hospital has several examination rooms where appointments take place. 
--Obtain the number of appointments that have taken place in each examination room.
SELECT DISTINCT
	ExaminationRoom,
	count(AppointmentID) OVER (PARTITION BY ExaminationRoom) As AppointmentNumber
FROM Appointment

-- 8.9 Obtain the names of all patients and their primary care physician, such that the following are true:
    -- The patient has been prescribed some medication by his/her primary care physician.
    -- The patient has undergone a procedure with a cost larger that $5,000
    -- The patient has had at least two appointments where the nurse who prepared the appointment was a registered nurse.
    -- The patient's primary care physician is not the head of any department.
WITH PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment AS(	
	WITH PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse AS(	
		WITH PatientIdWithPrimaryPhysicianId_Above5000Procedure AS(
			WITH PatientIdWithPrimaryPhysicianId AS(
				WITH DefPrimaryCarePhysician AS(SELECT DISTINCT 
					Appointment.Patient AS PatientID,
					first_value(Appointment.Physician) OVER(PARTITION BY Appointment.Patient ORDER BY Appointment.Start ASC) AS PhysicianPrimaryCareID
				FROM Appointment)
				SELECT 
					DefPrimaryCarePhysician.PatientID,
					DefPrimaryCarePhysician.PhysicianPrimaryCareID
				FROM Prescribes
				JOIN DefPrimaryCarePhysician
					ON Prescribes.Physician=DefPrimaryCarePhysician.PhysicianPrimaryCareID)
			SELECT
				PatientIdWithPrimaryPhysicianId.PatientID,
				PatientIdWithPrimaryPhysicianId.PhysicianPrimaryCareID
				--Undergoes.Procedure,
				--Procedures.Code,
				--Procedures.Cost
			FROM PatientIdWithPrimaryPhysicianId
			JOIN Undergoes
				ON PatientIdWithPrimaryPhysicianId.PatientID=Undergoes.Patient
			JOIN Procedures
				ON Procedures.Code=Undergoes.Procedure
			WHERE Procedures.Cost > 5000)
		SELECT
			PatientIdWithPrimaryPhysicianId_Above5000Procedure.*,
			--PatientIdWithPrimaryPhysicianId_Above5000Procedure.PhysicianID,
			Appointment.PrepNurse,
			Appointment.AppointmentID,
			Nurse.Registered,
			sum(Nurse.Registered) OVER(PARTITION BY PatientIdWithPrimaryPhysicianId_Above5000Procedure.PatientID) AS AppointmentAmount
			FROM PatientIdWithPrimaryPhysicianId_Above5000Procedure
		JOIN Appointment
			ON PatientIdWithPrimaryPhysicianId_Above5000Procedure.PatientID=Appointment.Patient
		JOIN Nurse
			ON Nurse.EmployeeID=Appointment.PrepNurse
		WHERE Nurse.Registered=1)
	SELECT DISTINCT
		PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse.PatientID,
		PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse.PhysicianPrimaryCareID	
	FROM PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse
	WHERE PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse.AppointmentAmount >= 2)
SELECT
	--PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment.PatientID,
	Patient.Name AS PatientName,
	--PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment.PhysicianPrimaryCareID,
	Physician.Name AS PhysicianName_PrimaryCare
FROM PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment
LEFT JOIN Department
	ON PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment.PhysicianPrimaryCareID=Department.Head
JOIN Patient
	ON PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment.PatientID=Patient.SSN
JOIN Physician
	ON PatientIdWithPrimaryPhysicianId_Above5000Procedure_RegisteredPrepNurse_Min2Appointment.PhysicianPrimaryCareID=Physician.EmployeeID
WHERE Department.Head IS NULL

-- below is just a test to find last care physician ID by patient ID	
WITH DefLastCarePhysician_Step1 AS(SELECT DISTINCT
	Appointment.Patient AS PatientName,
	last_value(Appointment.Physician) OVER(PARTITION BY Appointment.Patient ORDER BY Appointment.Start ASC
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS PhysicianLastCareID
FROM Appointment)

USE master
GO 
DROP DATABASE VetClinic
GO
CREATE DATABASE VetClinic
GO
USE VetClinic
GO
/*0 Уровень*/

CREATE TABLE Position /*Должность*/
(
	PositionID INT PRIMARY KEY, 
	PositionName VARCHAR(255) NOT NULL
)
GO

CREATE TABLE PayentMetod /*Способ оплаты*/
(
	PayentMetodID INT PRIMARY KEY,
	PayentMetodName VARCHAR(255) NOT NULL
)
GO

CREATE TABLE Kind /*Вид (животного)*/
(
	KindID INT PRIMARY KEY,	
	KindName VARCHAR(255) NOT NULL
)
GO

CREATE TABLE ServiceName /*Услуга*/
(
	ServiceNameID INT PRIMARY KEY,
	ServiceNameName VARCHAR(255) NOT NULL
)
GO

CREATE TABLE Result /*Результат*/
(
	ResultID INT PRIMARY KEY,
	ResultName VARCHAR(255) NOT NULL
)
GO

/*1 Уровень*/

CREATE TABLE Employee /*Сотрудник*/
(
	EmployeeID INT PRIMARY KEY,
	LastName VARCHAR (255) NOT NULL,
	FirstName VARCHAR (255) NOT NULL,
	MiddleName VARCHAR(255) NOT NULL,
	PositionID INT NOT NULL REFERENCES Position (PositionID)
)
GO

/*2 Уровень*/

CREATE TABLE Schedule /*График работы*/
(
	ScheduleID INT PRIMARY KEY,
	StartReceiving TIME (0) NOT NULL,
	EndOfReception TIME (0) NOT NULL,
	DateOfSchedule DATE NOT NULL,
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO

CREATE TABLE PriceList
(
	PriceListID INT PRIMARY KEY,
	Price VARCHAR (255) NOT NULL,
	ServiceNameID INT NOT NULL REFERENCES ServiceName (ServiceNameID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO

/*3 Уровень*/

CREATE TABLE Proprietor /*Хозяин*/
(
	ProprietorID INT PRIMARY KEY,
	LastName VARCHAR (255) NOT NULL,
	FirstName VARCHAR (255) NOT NULL,
	MiddleName VARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR (255) NOT NULL,
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID),
	PriceListID INT NOT NULL REFERENCES PriceList (PriceListID)
)
GO

/*4 Уровень*/

CREATE TABLE Animal 
(
	AnimalID INT PRIMARY KEY,
	NameAnimal VARCHAR (255) NOT NULL,
	DateOfBirth DATE NOT NULL,
	KindID INT NOT NULL REFERENCES Kind (KindID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID),
	ProprietorID INT NOT NULL REFERENCES Proprietor (ProprietorID)
)
GO



/*5 Уровень*/
CREATE TABLE Appointment /*Запись на прием*/
(
	AppointmentID INT PRIMARY KEY,
	TimeOfReceipt TIME (0) NOT NULL,
	DateOfReceipt DATE NOT NULL,
	ScheduleID INT NOT NULL REFERENCES Schedule (ScheduleID),
	AnimalID INT NOT NULL REFERENCES Animal (AnimalID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO



/*6 Уровень*/

CREATE TABLE Inspection /*Осмотр*/
(
	InspectionID INT PRIMARY KEY,
	Anamnesis VARCHAR (255) NOT NULL,
	Heft VARCHAR (255) NOT NULL,
	Temperature VARCHAR (255) NOT NULL,
	AnimalID INT NOT NULL REFERENCES Animal (AnimalID),
	AppointmentID INT NOT NULL REFERENCES Appointment (AppointmentID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO

/*7 уровень*/

CREATE TABLE Discharge /*Выписка*/
(
	DischargeID INT PRIMARY KEY,
	DischargeDate DATE NOT NULL,
	InspectionID INT NOT NULL REFERENCES Inspection (InspectionID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO

CREATE TABLE TreatmentProcedure /*Лечебная процедура*/
(
	TreatmentProcedureID INT PRIMARY KEY,
	ResultID INT NOT NULL REFERENCES Result (ResultID),
	InspectionID INT NOT NULL REFERENCES Inspection (InspectionID),
	PriceListID INT NOT NULL REFERENCES PriceList (PriceListID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO

CREATE TABLE Diagnosis /*Диагноз*/
(
	DiagnosisID INT PRIMARY KEY,
	PreliminaryDiagnosis VARCHAR (255) NOT NULL, /*Предварительный диагноз*/
	FinalDiagnosis VARCHAR (255) NOT NULL, /*Окончательный диагноз*/
	InspectionID INT NOT NULL REFERENCES Inspection (InspectionID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID)
)
GO

CREATE TABLE Payment /*Оплата*/
(
	PaymentID INT PRIMARY KEY,
	Amount INT, /*Сумма*/
	PayentMetodID INT NOT NULL REFERENCES PayentMetod (PayentMetodID),
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID),
	ProprietorID INT NOT NULL REFERENCES Proprietor (ProprietorID),
	PriceListID INT NOT NULL REFERENCES PriceList (PriceListID),
	InspectionID INT NOT NULL REFERENCES Inspection (InspectionID)
)
GO

/*8 уровень*/

CREATE TABLE Treatment /*Лечение*/
(
	TreatmentID INT PRIMARY KEY,
	DoctorPrescriptions VARCHAR (255) NOT NULL,
	PrescribedMedication VARCHAR (255) NOT NULL,
	EmployeeID INT NOT NULL REFERENCES Employee (EmployeeID),
	DiagnosisID INT NOT NULL REFERENCES Diagnosis (DiagnosisID)
)
GO

CREATE TABLE Diagnostic /*Диагностирование*/
(
	DiagnosticID INT PRIMARY KEY,
	Quantity VARCHAR (255) NOT NULL,
	DateOfDiagnostic DATE NOT NULL,
	InspectionID INT NOT NULL REFERENCES Inspection (InspectionID),
	DiagnosisID INT NOT NULL REFERENCES Diagnosis (DiagnosisID)
)
GO

CREATE TABLE VeterinaryCare /*Оказание ветеринарной помощи*/
(
	VeterinaryCareID INT PRIMARY KEY,
	Quantity INT NOT NULL,
	DateOfVeterinaryCare DATE NOT NULL,
	PriceListID INT NOT NULL REFERENCES PriceList (PriceListID),
	TreatmentProcedureID INT NOT NULL REFERENCES TreatmentProcedure (TreatmentProcedureID),
	InspectionID INT NOT NULL REFERENCES Inspection (InspectionID)
)
GO

/*9 уровень*/

CREATE TABLE TreatmentAppointment /*Назначение лечения*/
(
	TreatmentAppointmentID INT PRIMARY KEY,
	Quantity VARCHAR (255) NOT NULL,
	DateOfTreatmentAppointment DATE NOT NULL,
	TreatmentID INT NOT NULL REFERENCES Treatment (TreatmentID),
	DiagnosisID INT NOT NULL REFERENCES Diagnosis (DiagnosisID)
)
GO

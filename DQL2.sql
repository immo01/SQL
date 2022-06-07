USE VetClinic 
GO
/* 1. Формирование графика работы определенного сотрудника */
DROP PROCEDURE EmployeeSchedule
GO
CREATE PROCEDURE EmployeeSchedule
	@LastName varchar(255),
	@FirstName varchar(255),
	@MiddleName varchar(255)
AS
	SELECT
		'ФИО сотрудника' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
		SC.StartReceiving AS 'Время начала приема',
		SC.EndOfReception AS 'Время конца приема',
		SC.DateOfSchedule AS 'Дата приема'
	FROM
		dbo.Schedule SC
	INNER JOIN dbo.Employee EM
		ON SC.EmployeeID = EM.EmployeeID
	WHERE (@LastName = EM.LastName AND @FirstName = EM.FirstName AND @MiddleName = EM.MiddleName)
GO
EXECUTE EmployeeSchedule 'Усольцева', 'Елена', 'Игоревна'
GO

/* 2. Формирование отчета о проведенных осмотрах врачами*/
DROP PROCEDURE InspectionsCarriedOut 
GO
CREATE PROCEDURE InspectionsCarriedOut
	@LastName varchar(255),
	@FirstName varchar(255),
	@MiddleName varchar(255)
AS
	SELECT
		'ФИО врача' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
		AP.DateOfReceipt AS 'Дата приема',
		AP.TimeOfReceipt AS 'Время приема',
		AN.NameAnimal AS 'Кличка животного'
	FROM
		dbo.Appointment AP

	INNER JOIN dbo.Employee EM
		ON AP.EmployeeID = EM.EmployeeID

	INNER JOIN dbo.Animal AN
		ON AN.AnimalID = AP.AnimalID

	WHERE (@LastName = EM.LastName AND @FirstName = EM.FirstName AND @MiddleName = EM.MiddleName)
GO
EXECUTE InspectionsCarriedOut  'Александров', 'Александ', 'Александрович'
GO

/*  3. Список работающих сотрудников на определенной должности*/
DROP FUNCTION WorkingEmployees
GO
CREATE FUNCTION WorkingEmployees(@PositionName VARCHAR (225))
RETURNS TABLE
AS
RETURN
	(SELECT DISTINCT
		'ФИО сотрудника' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
		POS.PositionName AS 'Должность'
	FROM
		dbo.Employee EM
	INNER JOIN dbo.Position POS
		ON EM.PositionID = POS.PositionID
	WHERE @PositionName = POS.PositionName)
GO
SELECT *
FROM WorkingEmployees('Врач-терапевт')
GO

/* 4. Формирование отчета о прайс-листе определенного составителя*/
DROP PROCEDURE PriceListEmp
GO
CREATE PROCEDURE PriceListEmp
	@LastName varchar(255),
	@FirstName varchar(255),
	@MiddleName varchar(255)
AS
	SELECT
		'ФИО составителя' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
	POS.PositionName AS 'Должность',
	PL.Price AS 'Цена',
	SN.ServiceNameName AS 'Услуга'
	FROM	dbo.PriceList PL

	INNER JOIN dbo.Employee EM
		ON PL.EmployeeID = EM.EmployeeID

	INNER JOIN dbo.ServiceName SN
		ON PL.ServiceNameID = SN.ServiceNameID

	INNER JOIN dbo.Position POS
		ON EM.PositionID = POS.PositionID

	WHERE	
		(@LastName = EM.LastName AND @FirstName = EM.FirstName AND @MiddleName = EM.MiddleName)
GO
EXECUTE PriceListEmp 'Галстян', 'Анна', 'Николаевна'
GO

/* 5. Формирование отчета о прибыли за определенный день */

DROP PROCEDURE DailyProfit
GO
CREATE PROCEDURE DailyProfit
	@DateOfReceipt varchar(255)
AS
	SELECT
		'Дата' = APP.DateOfReceipt,
		SUM (PAY.Amount) AS 'Общая выручка'
	FROM
		dbo.Payment PAY

	INNER JOIN dbo.Inspection INS
		ON PAY.InspectionID = INS.InspectionID

	INNER JOIN dbo.Appointment APP
		ON INS.AppointmentID = APP.AppointmentID
	WHERE (@DateOfReceipt = APP.DateOfReceipt)
			
			GROUP BY
			DateOfReceipt
GO
EXECUTE DailyProfit '2019-05-10'
GO


/* 6. Формирование отчета о количестве оплат определенного клиента */

DROP PROCEDURE NumberOfPayments
GO
CREATE PROCEDURE NumberOfPayments
	@PhoneNumber varchar(255)
AS
	SELECT
		'ФИО' = PR.LastName + ' ' + PR.FirstName + ' ' + PR.MiddleName,
		PR.PhoneNumber AS 'Номер телефона',
		COUNT (PAY.PaymentID) AS 'Количество оплат'
	FROM
		dbo.Payment PAY

	INNER JOIN dbo.Proprietor PR
		ON PAY.ProprietorID = PR.ProprietorID
	WHERE (@PhoneNumber = PR.PhoneNumber)
			
			GROUP BY
			FirstName,
			LastName,
			MiddleName,
			PhoneNumber
GO
EXECUTE NumberOfPayments '894543568301'
GO

/* 7. Формирование отчета о количестве животных определенного клиента */

DROP PROCEDURE KolAnimal
GO
CREATE PROCEDURE KolAnimal
	@PhoneNumber varchar(255)
AS
	SELECT
		PR.FirstName AS 'Имя',
		PR.LastName AS 'Фамилия',
		PR.PhoneNumber AS 'Номер телефона',
		COUNT (AN.AnimalID) AS 'Количество животных'
	FROM
		dbo.Animal AN

	INNER JOIN dbo.Proprietor PR
		ON AN.ProprietorID = PR.ProprietorID
	WHERE (@PhoneNumber = PR.PhoneNumber)
			
			GROUP BY
			FirstName,
			LastName,
			PhoneNumber
GO
EXECUTE KolAnimal '894543568301'
GO

/* 8. Формирование отчета о истории болезни определенного животного клиента */

DROP FUNCTION DiseaseHistory
GO
CREATE FUNCTION DiseaseHistory(@Phone VARCHAR (225), @Name VARCHAR (225))
RETURNS TABLE
AS
RETURN
	(SELECT DISTINCT
		'ФИО хозяина' = PR.LastName + ' ' + PR.FirstName + ' ' + PR.MiddleName,
		AN.NameAnimal AS 'Кличка',
		AN.DateOfBirth AS 'Дата рождения',
		DS.PreliminaryDiagnosis AS 'Предварительный диагноз',
		DS.FinalDiagnosis AS 'Окончательный диагноз'
	FROM
	dbo.Schedule SC,
	dbo.Diagnosis DS

	INNER JOIN dbo.Inspection INS
		ON DS.InspectionID = INS.InspectionID

	INNER JOIN dbo.Animal AN
		ON INS.AnimalID = AN.AnimalID

	INNER JOIN dbo.Proprietor PR
		ON AN.ProprietorID = PR.ProprietorID
	WHERE @Phone = PR.PhoneNumber AND @Name = AN.NameAnimal)
GO
SELECT *
FROM DiseaseHistory ('894543568301', 'Милан')
GO

	/*9.Формирование отчета о хозяевах и их питомцах*/

DROP PROCEDURE Cyrsor
GO
CREATE PROCEDURE Cyrsor
@fio varchar(255)
AS
DECLARE CyrsorInfo CURSOR
FOR
SELECT PR.LastName, PR.FirstName, PR.MiddleName, AN.NameAnimal
FROM dbo.Animal AN

INNER JOIN dbo.Proprietor PR
ON AN.ProprietorID = PR.ProprietorID

GROUP BY
FirstName,
LastName,
MiddleName,
NameAnimal

OPEN CyrsorInfo
DECLARE @LastName varchar (200)
DECLARE @FirstName varchar (200)
DECLARE @MiddleName varchar (200)
DECLARE @NameAnimal varchar (200)
DECLARE @i INT = 0
FETCH NEXT FROM CyrsorInfo INTO @LastName, @FirstName, @MiddleName, @NameAnimal
while @@FETCH_STATUS<>-1
begin
if (@LastName + ' ' + @FirstName + ' ' + @MiddleName = @fio AND @i = 0)
begin
set @i += 1
print ('Хозяин: ' + @LastName + ' ' + @FirstName + ' ' + @MiddleName)
print ('------------')
end
if (@LastName + ' ' + @FirstName + ' ' + @MiddleName = @fio)
begin
print ('Питомцы хозяина:')
print (' ' + @NameAnimal)
end
FETCH NEXT FROM CyrsorInfo INTO @LastName, @FirstName, @MiddleName, @NameAnimal
end
close CyrsorInfo
deallocate CyrsorInfo
go
execute Cyrsor 'Николаева Виктория Викторовна'
go

	/*10.Формирование отчета об животных определенного вида видах*/
	DROP PROCEDURE AnimalVid
GO
CREATE PROCEDURE AnimalVid
	@KindN varchar(255)
AS
	SELECT
		'ФИО хозяина' = PR.LastName + ' ' + PR.FirstName + ' ' + PR.MiddleName,
	AN.NameAnimal AS 'Кличка',
	KI.KindName AS 'Вид'
	FROM
		dbo.Animal AN

	INNER JOIN dbo.Kind KI
		ON AN.KindID = KI.KindID

	INNER JOIN dbo.Proprietor PR
		ON AN.ProprietorID = PR.ProprietorID
	WHERE (@KindN = KI.KindName)

GO
EXECUTE AnimalVid 'Собака'
GO



	/*11.Триггер, который делает общую оплату на основе прайс-листа и количества предоставленных услуг*/
	use VetClinic
go
CREATE TRIGGER SumPay
ON
dbo.Payment
AFTER
UPDATE, INSERT
AS
UPDATE
dbo.Payment
SET
Amount = PL.Price * CONVERT(INT, VC.Quantity)
FROM
dbo.VeterinaryCare VC
INNER JOIN dbo.PriceList PL
ON PL.PriceListID = VC.PriceListID
INNER JOIN inserted I
ON VC.InspectionID = I.InspectionID

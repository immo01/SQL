USE VetClinic
GO

/* 1. Формирование графика работы определенного сотрудника */
SELECT
	'ФИО сотрудника' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
	SC.StartReceiving AS 'Время начала приема',
	SC.EndOfReception AS 'Время конца приема',
	SC.DateOfSchedule AS 'Дата приема'
FROM
	dbo.Schedule SC
	INNER JOIN dbo.Employee EM
		ON SC.EmployeeID = EM.EmployeeID
WHERE
	EM.LastName = 'Усольцева'
	and
	EM.FirstName = 'Елена'
	and
	EM.MiddleName = 'Игоревна'
GO	   
	   
/* 2. Формирование отчета о проведенных осмотрах врачами*/
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
	
WHERE
	EM.LastName = 'Александров'
	and
	EM.FirstName = 'Александ'
	and
	EM.MiddleName = 'Александрович'
GO

/*  3. Список работающих сотрудников */
SELECT
	'ФИО сотрудника' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
	POS.PositionName AS 'Должность'
FROM
	dbo.Employee EM
	INNER JOIN dbo.Position POS
		ON EM.PositionID = POS.PositionID
GO

/* 4. Формирование отчета о прайс-листе  */
SELECT
	'ФИО составителя' = EM.LastName + ' ' + EM.FirstName + ' ' + EM.MiddleName,
	POS.PositionName AS 'Должность',
	PL.Price AS 'Цена',
	SN.ServiceNameName AS 'Услуга'
	
FROM
	dbo.PriceList PL

	INNER JOIN dbo.Employee EM
		ON PL.EmployeeID = EM.EmployeeID

	INNER JOIN dbo.ServiceName SN
		ON PL.ServiceNameID = SN.ServiceNameID

	INNER JOIN dbo.Position POS
		ON EM.PositionID = POS.PositionID
GO

/* 5. Формирование отчета о прибыли за определенный день */
SELECT
	'Дата' = APP.DateOfReceipt,
	SUM (PAY.Amount) AS 'Общая выручка'
FROM
	dbo.Payment PAY

	INNER JOIN dbo.Inspection INS
		ON PAY.InspectionID = INS.InspectionID

	INNER JOIN dbo.Appointment APP
		ON INS.AppointmentID = APP.AppointmentID

WHERE
	APP.DateOfReceipt = '2019-05-10'
GROUP BY
	DateOfReceipt

/* 6. Формирование отчета о количестве оплат определенного клиента */
SELECT
	PR.FirstName AS 'Имя',
	PR.LastName AS 'Фамилия',
	PR.PhoneNumber AS 'Номер телефона',
	COUNT (PAY.PaymentID) AS 'Количество заказов'
FROM

	dbo.Payment PAY

	INNER JOIN dbo.Proprietor PR
		ON PAY.ProprietorID = PR.ProprietorID
WHERE
	PR.PhoneNumber = '894543568301'
GROUP BY
	FirstName,
	LastName,
	PhoneNumber

	/* 7. Формирование отчета о количестве животных определенного клиента */
SELECT
	PR.FirstName AS 'Имя',
	PR.LastName AS 'Фамилия',
	PR.PhoneNumber AS 'Номер телефона',
	COUNT (AN.AnimalID) AS 'Количество животных'
FROM
	dbo.Animal AN

	INNER JOIN dbo.Proprietor PR
		ON AN.ProprietorID = PR.ProprietorID
WHERE
	PR.PhoneNumber = '894543568301'
GROUP BY
	FirstName,
	LastName,
	PhoneNumber

	/* 8. Формирование отчета о истории болезни определенного животного клиента */
SELECT
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


WHERE
	PR.PhoneNumber = '894543568301'
	and
	AN.NameAnimal = 'Милан'
GO	   

	/*9.Формирование отчета о хозяивах и их питомцах*/
SELECT
	'ФИО хозяина' = PR.LastName + ' ' + PR.FirstName + ' ' + PR.MiddleName,
	AN.NameAnimal AS 'Кличка'
FROM
	dbo.Animal AN
	
	INNER JOIN dbo.Proprietor PR
		ON AN.ProprietorID = PR.ProprietorID

GO

	/*10.Формирование отчета о животных и их видах*/
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

GO

--------------------------------------------------------------------------------
-- Задание 1: Запросы для таблицы с оценками студентов
--------------------------------------------------------------------------------

-- 1.1: Отображение всей информации из таблицы со студентами и оценками
-- Выводит все столбцы из таблицы Achievements и присоединяет к ним
-- фамилию и имя студента из таблицы Students.
SELECT a.*, s.LastName, s.FirstName
FROM Achievements a
INNER JOIN Students s ON a.StudentId = s.id;

-- 1.2: Отображение ФИО всех студентов
-- Выводит только фамилии и имена всех студентов из таблицы Students.
SELECT LastName, FirstName FROM Students;

-- 1.3: Отображение всех средних оценок по предметам
-- Вычисляет среднюю оценку по каждому предмету и выводит название предмета
-- и соответствующую среднюю оценку.
SELECT s.SubjectName, AVG(a.Assesment) AS AverageGrade
FROM Achievements a
INNER JOIN Subjects s ON a.SubjectId = s.id
GROUP BY s.SubjectName;

-- 1.4: Показать ФИО всех студентов с минимальной оценкой, больше, чем указанная (7)
-- Выводит ФИО студентов, у которых есть оценка выше 7.
SELECT DISTINCT s.LastName, s.FirstName
FROM Students s
INNER JOIN Achievements a ON s.id = a.StudentId
WHERE a.Assesment > 7;

-- 1.5: Показать страны студентов (В таблице Students нет столбца Country, демонстрация с LastName)
-- Демонстрация: показывает уникальные фамилии студентов.
SELECT DISTINCT LastName FROM Students;

-- 1.6: Показать города студентов (В таблице Students нет столбца City, демонстрация с FirstName)
-- Демонстрация: показывает уникальные имена студентов.
SELECT DISTINCT FirstName FROM Students;

-- 1.7: Показать названия групп
-- Выводит уникальные названия всех групп.
SELECT DISTINCT GroupName FROM Groups;

-- 1.8: Показать название всех предметов с минимальными средними оценками
-- Выводит название предмета с минимальной средней оценкой.
SELECT DISTINCT s.SubjectName
FROM Subjects s
INNER JOIN Achievements a ON s.id = a.SubjectId
WHERE s.id IN (
    SELECT SubjectId
    FROM (
        SELECT SubjectId, AVG(Assesment) AS AverageGrade
        FROM Achievements
        GROUP BY SubjectId
    ) AS SubjectAverages
    WHERE AverageGrade = (SELECT MIN(AverageGrade) FROM (SELECT SubjectId, AVG(Assesment) AS AverageGrade FROM Achievements GROUP BY SubjectId) AS Subquery)
);

--------------------------------------------------------------------------------
-- Задание 2: Запросы для базы данных с оценками студентов
--------------------------------------------------------------------------------

-- 2.1: Показать ФИО всех студентов с минимальной оценкой в указанном диапазоне (8-10)
-- Выводит ФИО студентов, у которых минимальная оценка находится в диапазоне от 8 до 10.
SELECT DISTINCT s.LastName, s.FirstName
FROM Students s
INNER JOIN Achievements a ON s.id = a.StudentId
WHERE a.Assesment IN (SELECT MIN(Assesment) FROM Achievements)
  AND a.Assesment BETWEEN 8 AND 10;

-- 2.2: Показать информацию о студентах, которым исполнилось 20 лет
-- Выводит информацию о студентах, чей возраст равен 20 годам на текущую дату.
SELECT *
FROM Students
WHERE DATEDIFF(year, BirthDate, GETDATE()) = 20;

-- 2.3: Показать информацию о студентах с возрастом в указанном диапазоне (19-21)
-- Выводит информацию о студентах, чей возраст находится в диапазоне от 19 до 21 года.
SELECT *
FROM Students
WHERE DATEDIFF(year, BirthDate, GETDATE()) BETWEEN 19 AND 21;

-- 2.4: Показать информацию о студентах с конкретным именем (John)
-- Выводит информацию о студентах с именем John.
SELECT *
FROM Students
WHERE FirstName = 'John';

-- 2.5: Показать информацию о студентах, в чьем номере встречаются три семерки (Демонстрация с ID)
-- Демонстрация: Поиск студентов, в ID которых есть "777".
SELECT *
FROM Students
WHERE CAST(id AS VARCHAR) LIKE '%777%';

-- 2.6: Показать электронные адреса студентов, начинающихся с конкретной буквы (j)
-- Выводит email-адреса студентов, начинающихся с буквы 'j'.
SELECT Email
FROM Students
WHERE Email LIKE 'j%';

--------------------------------------------------------------------------------
-- Задание 3: Запросы для базы данных с оценками студентов
--------------------------------------------------------------------------------

-- 3.1: Показать минимальную среднюю оценку по всем студентам
-- Вычисляет и выводит минимальную среднюю оценку среди всех студентов.
SELECT MIN(AverageGrade) AS MinAverageGrade
FROM (
    SELECT StudentId, AVG(Assesment) AS AverageGrade
    FROM Achievements
    GROUP BY StudentId
) AS StudentAverages;

-- 3.2: Показать максимальную среднюю оценку по всем студентам
-- Вычисляет и выводит максимальную среднюю оценку среди всех студентов.
SELECT MAX(AverageGrade) AS MaxAverageGrade
FROM (
    SELECT StudentId, AVG(Assesment) AS AverageGrade
    FROM Achievements
    GROUP BY StudentId
) AS StudentAverages;

-- 3.3: Показать статистику городов студентов (В таблице Students нет столбца City, демонстрация с LastName)
-- Демонстрация: показывает количество студентов с одинаковой фамилией.
SELECT LastName, COUNT(*) AS NumberOfStudents FROM Students GROUP BY LastName;

-- 3.4: Показать статистику стран студентов (В таблице Students нет столбца Country, демонстрация с FirstName)
-- Демонстрация: показывает количество студентов с одинаковым именем.
SELECT FirstName, COUNT(*) AS NumberOfStudents FROM Students GROUP BY FirstName;

-- 3.5: Показать количество студентов, у которых минимальная средняя оценка по математике (Предмет "Математика" с ID = 2)
-- Выводит количество студентов с минимальной средней оценкой по предмету "Математика" (ID = 2).
SELECT COUNT(*) AS NumberOfStudents
FROM (
    SELECT StudentId, AVG(Assesment) AS AverageGrade
    FROM Achievements
    WHERE SubjectId = 2  -- Замените на реальный ID предмета "Математика"
    GROUP BY StudentId
) AS MathAverages
WHERE AverageGrade = (
    SELECT MIN(AverageGrade)
    FROM (
        SELECT StudentId, AVG(Assesment) AS AverageGrade
        FROM Achievements
        WHERE SubjectId = 2  -- Замените на реальный ID предмета "Математика"
        GROUP BY StudentId
    ) AS MinMathAverages
);

-- 3.6: Показать количество студентов, у которых максимальная средняя оценка по математике (Предмет "Математика" с ID = 2)
-- Выводит количество студентов с максимальной средней оценкой по предмету "Математика" (ID = 2).
SELECT COUNT(*) AS NumberOfStudents
FROM (
    SELECT StudentId, AVG(Assesment) AS AverageGrade
    FROM Achievements
    WHERE SubjectId = 2  -- Замените на реальный ID предмета "Математика"
    GROUP BY StudentId
) AS MathAverages
WHERE AverageGrade = (
    SELECT MAX(AverageGrade)
    FROM (
        SELECT StudentId, AVG(Assesment) AS AverageGrade
        FROM Achievements
        WHERE SubjectId = 2  -- Замените на реальный ID предмета "Математика"
        GROUP BY StudentId
    ) AS MaxMathAverages
);

-- 3.7: Показать количество студентов в каждой группе
-- Выводит название группы и количество студентов в каждой группе.
SELECT g.GroupName, COUNT(s.id) AS NumberOfStudents
FROM Groups g
LEFT JOIN Students s ON g.Id = s.GroupId
GROUP BY g.GroupName;

-- 3.8: Показать среднюю оценку по группе
-- Выводит название группы и среднюю оценку по каждой группе.
SELECT g.GroupName, AVG(a.Assesment) AS AverageGrade
FROM Groups g
INNER JOIN Students s ON g.Id = s.GroupId
INNER JOIN Achievements a ON s.id = a.StudentId
GROUP BY g.GroupName;
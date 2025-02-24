SELECT a.*, s.LastName, s.FirstName
FROM Achievements a
INNER JOIN Students s ON a.StudentId = s.id;

SELECT LastName, FirstName FROM Students;

SELECT s.SubjectName, AVG(a.Assesment) AS AverageGrade
FROM Achievements a
INNER JOIN Subjects s ON a.SubjectId = s.id
GROUP BY s.SubjectName;

SELECT DISTINCT s.LastName, s.FirstName
FROM Students s
INNER JOIN Achievements a ON s.id = a.StudentId
WHERE a.Assesment > 7;

--SELECT DISTINCT Country FROM Students; -- В таблице Students нет столбца Country
--Для демонстрации, покажу все фамилии.
SELECT DISTINCT LastName FROM Students;

--SELECT DISTINCT City FROM Students;  -- В таблице Students нет столбца City
--Для демонстрации, покажу все имена.
SELECT DISTINCT FirstName FROM Students;

SELECT DISTINCT GroupName FROM Groups;

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
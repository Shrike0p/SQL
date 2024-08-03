```sql
CREATE PROCEDURE UpdateSubjectAllotments
AS
BEGIN
    DECLARE @StudentID VARCHAR(50), @SubjectID VARCHAR(50), @CurrentSubjectID VARCHAR(50)
    
    DECLARE request_cursor CURSOR FOR
    SELECT StudentID, SubjectID
    FROM SubjectRequest

    OPEN request_cursor
    FETCH NEXT FROM request_cursor INTO @StudentID, @SubjectID

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if the student has a currently valid subject
        SELECT @CurrentSubjectID = SubjectID
        FROM SubjectAllotments
        WHERE StudentID = @StudentID AND Is_Valid = 1

        IF @CurrentSubjectID IS NULL
        BEGIN
            -- Insert the new subject as valid if no valid subject currently exists
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @SubjectID, 1)
        END
        ELSE IF @CurrentSubjectID <> @SubjectID
        BEGIN
            -- Invalidate the current valid subject
            UPDATE SubjectAllotments
            SET Is_Valid = 0
            WHERE StudentID = @StudentID AND SubjectID = @CurrentSubjectID

            -- Insert the new subject as valid
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @SubjectID, 1)
        END

        FETCH NEXT FROM request_cursor INTO @StudentID, @SubjectID
    END

    CLOSE request_cursor
    DEALLOCATE request_cursor
END
```

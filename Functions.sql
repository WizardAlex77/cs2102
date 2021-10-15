/*---------------------------------------------------------*/

--declare_health

CREATE OR REPLACE PROCEDURE DeclareHealth
(IN EmployeeID INTEGER, IN Date DATE, IN Temperature NUMERIC(3,1))
AS $$
BEGIN
	IF (NOT EXISTS(SELECT 1 FROM HealthDeclarations WHERE eid = EmployeeID AND ddate = Date)) THEN
		INSERT INTO HealthDeclarations
		VALUES (Date, EmployeeID, Temperature, false);
	ELSE
		UPDATE HealthDeclarations
		SET temp = Temperature
		WHERE eid = EmployeeID AND ddate = Date;
	END IF;
END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/
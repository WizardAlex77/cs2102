/*---------------------------------------------------------*/
/* BASIC FUNCTIONALITIES */
/*---------------------------------------------------------*/

--add_department

CREATE OR REPLACE PROCEDURE add_department(department_id INTEGER, department_name VARCHAR(255))
AS $$
BEGIN
	IF (NOT EXISTS(select 1 from Departments where Departments.did = department_id)) THEN
		IF (NOT EXISTS(select 1 from Departments where Departments.dname = department_name)) THEN
			insert into Departments values (department_id, department_name);
			RAISE NOTICE 'Department added successfully!';
		ELSE
			RAISE EXCEPTION '% department already exists!', department_name;
		END IF;
	ELSE
		RAISE EXCEPTION 'Department ID already exists!';
	END IF;
END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

--remove_department

CREATE OR REPLACE PROCEDURE remove_department(department_id_to_remove INTEGER, new_department_id INTEGER)
AS $$
DECLARE
	curs CURSOR FOR (select e.eid, e.did from Employees e where e.did = department_id_to_remove);
	r1 RECORD;
BEGIN
	IF (NOT EXISTS(select 1 from Departments where Departments.did = department_id_to_remove)) THEN
		RAISE EXCEPTION 'Department to be removed does not exist!';
	END IF;

	IF (NOT EXISTS(select 1 from Departments where Departments.did = new_department_id)) THEN
	RAISE EXCEPTION 'Employees cannot be transferred to non-existent department!';
	END IF;

	OPEN curs;
	LOOP
		FETCH curs INTO r1; 
		EXIT WHEN NOT FOUND;
		update Employees set did = new_department_id where eid = r1.eid;
	END LOOP;
	RAISE NOTICE 'Department deleted successfully!';
END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

--add_employee

CREATE OR REPLACE PROCEDURE add_employee(ename VARCHAR(255), email VARCHAR(255), etype VARCHAR(10), did INTEGER,
    mp_num INTEGER, op_num INTEGER, hp_num INTEGER, department ?????)

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

--This function serves to do contact tracing on an employee
--param EmployeeID: eid of employee for contact tracing to be conducted on
--param CDate: date to start contact tracing from
--return: list of employees in close contact with target employee within past 3 days

/*  First finds all meeting rooms visited by employee within past 3 days. Cross reference to Joins to find
employees present in those meetings. Iterates over the result table using a cursor, conducting measures
on affected employees. Finally, removes employee with fever from all future meetings.
*/

CREATE OR REPLACE FUNCTION contact_tracing
(IN EmployeeID INTEGER, IN CDate DATE)
RETURNS TABLE(ContactEmployeeID INTEGER) AS $$
DECLARE 
	curs CURSOR FOR (SELECT * FROM 
						(SELECT DISTINCT J.eid FROM Joins J, 
						(SELECT sdate, stime, sroom, sfloor FROM Joins WHERE eid = EmployeeID AND sdate >= (date CDate - integer '3') AND sdate <= CDate) PCase
				 		WHERE J.eid <> EmployeeID 
				 		AND J.sdate = PCase.sdate 
				 		AND J.stime = PCase.stime 
				 		AND J.sroom = PCase.sroom
						AND J.sfloor = PCase.sfloor) FPCase
					 );
	r1 RECORD;
BEGIN
	OPEN curs;
	
	LOOP
		FETCH curs INTO r1;
		EXIT WHEN NOT FOUND;
		CALL contact_tracing_helper(r1.eid, CDate);
		RETURN NEXT;
	END LOOP;

	CLOSE curs;

	CALL remove_employee_all_future_meetings(EmployeeID, CDate);

END;
$$ LANGUAGE plpgsql;

--This helper procedure serves to remove an employee from their future meetings within the next 7 days
--Helper function, not called directly

CREATE OR REPLACE PROCEDURE contact_tracing_helper
(IN EmployeeID INTEGER, IN CDate DATE)
AS $$
BEGIN	
	DELETE FROM Joins 
	WHERE eid = EmployeeID
	AND sdate + stime > CDate + CURRENT_TIME
	AND sdate <= CDate + 7;
END;
$$ language plpgsql;

--This helper procedure serves to remove the specified employee from all future meetings.
--Helper function, not called directly

CREATE OR REPLACE PROCEDURE remove_employee_all_future_meetings
(IN EmployeeID INTEGER, IN CDate DATE)
AS $$
BEGIN	
	DELETE FROM Joins 
	WHERE eid = EmployeeID
	AND sdate + stime > CDate + CURRENT_TIME;
END;
$$ language plpgsql;


/*---------------------------------------------------------*/


--This trigger and trigger function serves to toggle the fever field of a newly inserted declaration in HealthDeclarations to true/false 
--Condition : Temperature must be 37.5 or above to have a fever

CREATE OR REPLACE FUNCTION detect_fever() RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.temp >= 37.5) THEN
		NEW.fever := true;
	ELSE NEW.fever := false;
	END IF; RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER fever_detector 
BEFORE INSERT OR UPDATE ON HealthDeclarations
FOR EACH ROW EXECUTE FUNCTION detect_fever();

/*---------------------------------------------------------*/

--unsure of how this functionality is supposed to work, waiting for prof reply

/*
--This trigger and trigger function serves to detect if the booker has been removed from a meeting
--If so, removes all participants from the meeting and disbands the meeting
--Condition : No eid = booker id in Joins for a particular Session.


CREATE OR REPLACE FUNCTION detect_booker() RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS (SELECT 1 FROM Sessions S
				WHERE OLD.eid = S.bookerid
				AND OLD.sdate = S.sdate
				AND OLD.stime = S.stime
				AND OLD.sroom = S.sroom
				AND OLD.sfloor = S.sfloor)
	THEN 
		DELETE FROM Joins WHERE OLD.sdate = sdate
							AND OLD.stime = stime
							AND OLD.sroom = sroom
							AND OLD.sfloor = sfloor;
		DELETE FROM Sessions WHERE OLD.sdate = sdate
							AND OLD.stime = stime
							AND OLD.sroom = sroom
							AND OLD.sfloor = sfloor;
END IF; RETURN OLD;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER booker_detector
AFTER DELETE ON Joins
FOR EACH ROW EXECUTE FUNCTION detect_booker();
*/


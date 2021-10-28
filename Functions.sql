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

	-- loop through employees in old department
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

--add_room

CREATE OR REPLACE PROCEDURE add_room(floor_number INTEGER, room_number INTEGER, room_name VARCHAR(255), room_capacity INTEGER, department_id INTEGER)
AS $$
BEGIN
	/* check if meeting room exists */
	IF (NOT EXISTS(select 1 from MeetingRooms where room = room_number AND floor = floor_number)) THEN
		/* check if department exists */
		IF (NOT EXISTS(select 1 from Departments where Departments.did = department_id)) THEN
			RAISE EXCEPTION 'Department does not exist!'; 
		ELSE
			insert into MeetingRooms values (floor_number, room_number, room_name, department_id);
			insert into Updates (floor, room, capacity) values (floor_number, room_number, room_capacity);
			RAISE NOTICE 'Meeting room added successfully!';
		END IF;
	ELSE
		RAISE EXCEPTION 'Meeting room #%-% already exists!', floor_number, room_number; 
	END IF;
END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

--change_capacity
CREATE OR REPLACE PROCEDURE change_capacity(floor_number INTEGER, room_number INTEGER, new_capacity INTEGER, date_changed DATE)
AS $$
BEGIN
	IF (NOT EXISTS(select 1 from MeetingRooms where room = room_number AND floor = floor_number)) THEN
		RAISE EXCEPTION 'Meeting room does not exist!';
	ELSE
		update Updates set capacity = new_capacity where floor = floor_number and room = room_number;
		update Updates set udate = date_changed where floor = floor_number and room = room_number;
		RAISE NOTICE 'Meeting room capacity for #%-% has been changed!', floor_number, room_number; 
	END IF;
END
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

--add_employee

CREATE OR REPLACE PROCEDURE add_employee(employee_name VARCHAR(255), employee_type VARCHAR(10), department_name VARCHAR(255),
    mobile_num INTEGER, office_num INTEGER, home_num INTEGER)

AS $$
DECLARE
	department_id INTEGER;
	employee_email VARCHAR(255);
BEGIN
	select concat(employee_name, );
 
	select d_id into department_id from find_department_id(department_name);
	insert into Employees (email, etype, did, mp_num, op_num, hp_num, resignation_date)
	values ()

-- eid INTEGER SERIAL PRIMARY KEY,
--     ename VARCHAR(255) NOT NULL, -> auto generated
--     email VARCHAR(255) UNIQUE NOT NULL, -> auto generated
--     etype VARCHAR(10) NOT NULL,
--     did INTEGER NOT NULL,
--     mp_num INTEGER,
--     op_num INTEGER,
--     hp_num INTEGER,
--     resignation_date DATE,
END
$$ LANGUAGE plpgsql;

--helper method
CREATE OR REPLACE FUNCTION find_department_id(IN department_name VARCHAR(255), OUT d_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
	select did into d_id 
	from Departments 
	where dname = department_name;

END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

--remove_employee
CREATE OR REPLACE PROCEDURE remove_employee(employee_id INTEGER, last_day_of_work DATE)
AS $$
BEGIN
	IF (NOT EXISTS(select 1 from Employees where eid = employee_id)) THEN
		RAISE EXCEPTION 'Employee does not exist!';
	ELSE
		update Employees set resignation_date = last_day_of_work where eid = employee_id;
		RAISE NOTICE 'Employee record % has been updated.', employee_id;
	END IF;
END
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/
/* CORE */
/*---------------------------------------------------------*/

-- join_meeting

CREATE OR REPLACE PROCEDURE join_meeting
(mfloor INTEGER, mroom INTEGER, mdate DATE, mshour TIME, mehour TIME, emp INTEGER)
AS $$
DECLARE 
    temp TIME := mshour;
    cap INTEGER;
BEGIN
    
    IF ((EXISTS(SELECT 1 FROM Sessions WHERE sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor AND approval_status IS NULL)) 
    AND (NOT EXISTS(SELECT 1 FROM Joins WHERE eid = emp AND sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor))) THEN

        --SELECT u.capacity INTO cap FROM Updates u WHERE room = mroom AND floor = mfloor ORDER BY udate DESC LIMIT 1;
        --SELECT rcapacity INTO cap FROM MeetingRooms WHERE room = mroom AND floor = mfloor;
		SELECT u.capacity INTO cap FROM Updates u WHERE u.udate = (SELECT MAX(udate) FROM Updates WHERE room = mroom AND floor = mfloor) AND room = mroom AND floor = mfloor;
        IF ((SELECT s.participants FROM Sessions s WHERE sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor) < cap) THEN
            WHILE temp < mehour LOOP
                INSERT INTO Joins
                VALUES (emp, mdate, temp, mfloor, mroom);
                
                UPDATE Sessions 
                SET participants = participants + 1 
                WHERE sdate = mdate 
                AND stime = temp 
                AND sroom = mroom 
                AND sfloor = mfloor;
                
                temp := temp + interval '1 hour';
            END LOOP;
        ELSE
            RAISE NOTICE 'room capacity reached';
        END IF;
    ELSE 
        RAISE NOTICE 'session does not exist or has already been finalized or employee already joined';

    END IF;

END;
$$ LANGUAGE plpgsql;

-- book_room needs to call join meeting as well since employee who booked is considered a participant
-- function assumes that if the meeting exists, that the end hour is correct.
/*---------------------------------------------------------*/

-- leave_meeting

CREATE OR REPLACE PROCEDURE leave_meeting
(mfloor INTEGER, mroom INTEGER, mdate DATE, mshour TIME, mehour TIME, emp INTEGER)
AS $$
DECLARE
    temp TIME := mshour;
BEGIN

    IF ((EXISTS(SELECT 1 FROM Sessions WHERE sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor AND approval_status IS NULL)) 
    AND (EXISTS(SELECT 1 FROM Joins WHERE eid = emp AND sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor))) THEN

        WHILE temp < mehour LOOP
            DELETE FROM Joins 
            WHERE eid = emp
            AND sdate = mdate
            AND stime = temp
            AND sfloor = mfloor
            AND sroom  = mroom;
           

            UPDATE Sessions
            SET participants = participants - 1
            WHERE sdate = mdate
            AND stime = temp
            AND sroom = mroom
            AND sfloor = mfloor;

            temp := temp + interval '1 hour';
        END LOOP;

    ELSE 
        RAISE NOTICE 'session does not exist or has already been finalized or employee is not part of meeting';

    END IF;

END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

-- approve_meeting

CREATE OR REPLACE PROCEDURE approve_meeting
(mfloor INTEGER, mroom INTEGER, mdate DATE, mshour TIME, mehour TIME, emp INTEGER, decision VARCHAR(10))
AS $$
DECLARE
    temp TIME := mshour;
BEGIN

    IF (EXISTS(SELECT 1 FROM Sessions WHERE sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor AND approval_status IS NULL)) THEN
        IF (((SELECT etype FROM Employees WHERE eid = emp) = 'Manager')
        AND ((SELECT did FROM Employees WHERE eid = emp) = (SELECT did FROM MeetingRooms WHERE floor = mfloor AND room = mroom))) THEN
            WHILE temp < mehour LOOP
                UPDATE Sessions
                SET approval_status = decision
                WHERE sdate = mdate
                AND stime = mshour
                AND sroom = mroom
                AND sfloor = mfloor;
                temp := temp + interval '1 hour';
            END LOOP;
        
        ELSE 
            RAISE NOTICE 'approver does not have approval rights for this room';

        END IF;

    ELSE
        RAISE NOTICE 'session does not exist or has already been approved';

    END IF;
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION delete_meeting() 
-- RETURNS TRIGGER AS $$
-- BEGIN
--     DELETE FROM Sessions
--     WHERE approval_status = 'rejected';
-- 	RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER reject_meeting
-- AFTER INSERT OR UPDATE ON Sessions
-- --FOR EACH ROW WHEN (NEW.approval_status = 'rejected')
-- EXECUTE PROCEDURE delete_meeting();

CREATE OR REPLACE FUNCTION delete_meeting() 
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Sessions
    WHERE approval_status = 'rejected';
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reject_meeting
AFTER INSERT OR UPDATE ON Sessions
EXECUTE PROCEDURE delete_meeting();
-- trigger is not compiling
-- employee must be a manager from the same department 
/*---------------------------------------------------------*/


/*---------------------------------------------------------*/
/* HEALTH */
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
			(SELECT sdate, stime, sroom, sfloor 
			FROM Joins J1
			WHERE eid = EmployeeID 
			AND sdate >= (CDate - integer '3') 
			AND sdate <= CDate
			AND EXISTS(SELECT 1 FROM Sessions S
				WHERE J1.sdate = S.sdate
				AND J1.stime = S.stime 
				AND J1.sroom = S.sroom
				AND J1.sfloor = S.sfloor
				AND S.approval_status = 'approved')) PCase
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
		ContactEmployeeID := r1.eid;
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
		DELETE FROM Joins 
			WHERE OLD.sdate = sdate
			AND OLD.stime = stime
			AND OLD.sroom = sroom
			AND OLD.sfloor = sfloor;
		DELETE FROM Sessions 
			WHERE OLD.sdate = sdate
			AND OLD.stime = stime
			AND OLD.sroom = sroom
			AND OLD.sfloor = sfloor;
END IF; RETURN OLD;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER booker_detector
AFTER DELETE ON Joins
FOR EACH ROW EXECUTE FUNCTION detect_booker();

/*---------------------------------------------------------*/

CREATE OR REPLACE FUNCTION non_compliance 
(IN StartDate DATE, IN EndDate DATE)
RETURNS TABLE(EmployeeID INTEGER, Days INTEGER) AS $$
	SELECT eid, ((EndDate - StartDate + 1) - count(*)) as days
	FROM HealthDeclarations
	WHERE ddate >= StartDate
	AND ddate <= EndDate
	GROUP BY eid 
	HAVING (EndDate - StartDate + 1) - COUNT(*) > 0
	ORDER BY days DESC;
$$ language sql;

/*---------------------------------------------------------*/

CREATE OR REPLACE FUNCTION view_booking_report
(IN StartDate DATE, IN EmployeeID INTEGER)
RETURNS TABLE(Floor_number INTEGER, Room_number INTEGER, Date DATE, Start_hour TIME, Is_approved BOOLEAN) AS $$
	SELECT sfloor, sroom, sdate, stime, CASE approval_status WHEN 'approved' THEN true ELSE false END
	FROM Sessions
	WHERE bookerid = EmployeeID
	AND sdate >= StartDate
	ORDER BY sdate ASC, stime ASC;
$$ language sql;



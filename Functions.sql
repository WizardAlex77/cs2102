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
	curs1 CURSOR FOR (select e.eid, e.did from Employees e where e.did = department_id_to_remove);
	r1 RECORD;
	curs2 CURSOR FOR (select m.floor, m.room, m.did from MeetingRooms m where m.did = department_id_to_remove);
	r2 RECORD;
BEGIN
	IF (NOT EXISTS(select 1 from Departments where Departments.did = department_id_to_remove)) THEN
		RAISE EXCEPTION 'Department to be removed does not exist!';
	END IF;

	IF (NOT EXISTS(select 1 from Departments where Departments.did = new_department_id)) THEN
		RAISE EXCEPTION 'Employees cannot be transferred to non-existent department!';
	END IF;

	-- loop through employees in old department
	OPEN curs1;
	LOOP
		FETCH curs1 INTO r1; 
		EXIT WHEN NOT FOUND;
		update Employees set did = new_department_id where eid = r1.eid;
	END LOOP;

	-- loop through meetingrooms in old department
	OPEN curs2;
	LOOP
		FETCH curs2 INTO r2;
		EXIT WHEN NOT FOUND;
		update MeetingRooms set did = new_department_id where floor = r2.floor and room = r2.room;
	END LOOP;

	DELETE FROM Departments WHERE did = department_id_to_remove;
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
CREATE OR REPLACE PROCEDURE change_capacity(floor_number INTEGER, room_number INTEGER, new_capacity INTEGER, date_changed DATE, employee_id INTEGER)
AS $$
BEGIN
	IF (NOT EXISTS(select 1 from MeetingRooms where room = room_number AND floor = floor_number)) THEN
		RAISE EXCEPTION 'Meeting room does not exist!';
	ELSE
		IF (NOT EXISTS(select 1 from Employees where eid = employee_id)) THEN
			RAISE EXCEPTION 'Employee record does not exist!'; 
		ELSE
			IF ((select e.etype from Employees e where e.eid = employee_id) = 'Manager') THEN
				IF (NOT EXISTS(select 1 from Updates where udate = date_changed)) THEN
					--there has already been an update to room capacity on the same day
					insert into Updates values (date_changed, floor_number, room_number, new_capacity);
					RAISE NOTICE 'Meeting room capacity for #%-% has been updated!', floor_number, room_number;
				ELSE
					--eg. if manager made a mistake in setting new room capacity
					update Updates set capacity = new_capacity where udate = date_changed;
					RAISE NOTICE 'Meeting room capacity for #%-% has been updated!', floor_number, room_number;
				END IF;
			ELSE
				RAISE EXCEPTION 'Only a MANAGER can change room capacity.';
			END IF;
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/

--add_employee

CREATE OR REPLACE PROCEDURE add_employee(employee_name VARCHAR(255), employee_type VARCHAR(10), department_id INTEGER,
    mobile_num INTEGER, office_num INTEGER, home_num INTEGER)
AS $$
BEGIN
	IF (NOT EXISTS(select 1 from Employees where mp_num = mobile_num)) THEN
		IF (employee_type not in ('Manager', 'Junior', 'Senior')) THEN
			RAISE EXCEPTION 'Employee type is invalid.';
		ELSE
			insert into Employees (ename, email, etype, did, mp_num, op_num, hp_num)
			values (employee_name, 'temp@company.com', employee_type, department_id, mobile_num, office_num, home_num);
			RAISE NOTICE 'Employee record created successfully!';
		END IF;
	ELSE
		RAISE EXCEPTION 'Employee record already exists!'; -- check error
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_employee_email()
RETURNS TRIGGER AS $$
BEGIN
	update Employees set email = (concat(replace(lower(NEW.ename), ' ', ''), '_', NEW.eid,'@company.com')) where eid = NEW.eid;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_employee_email
AFTER INSERT ON Employees
FOR EACH ROW EXECUTE FUNCTION generate_employee_email();

/*---------------------------------------------------------*/

--remove_employee
CREATE OR REPLACE PROCEDURE remove_employee(employee_id INTEGER, last_day_of_work DATE)
AS $$
BEGIN
	IF (NOT EXISTS(select 1 from Employees where eid = employee_id)) THEN
		RAISE EXCEPTION 'Employee does not exist!';
	ELSE
		update Employees set resignation_date = last_day_of_work where eid = employee_id;
		RAISE NOTICE 'Employee % has resigned and record is updated.', employee_id;
	END IF;
END
$$ LANGUAGE plpgsql;

/*---------------------------------------------------------*/
/* CORE */
/*---------------------------------------------------------*/

--search_room

CREATE OR REPLACE FUNCTION search_room (Date DATE, Start_hour TIME, End_hour TIME) 
RETURNS TABLE(Floor_number INT, Room_number INT, Department_ID INT, Capacity INT) 
AS $$

	SELECT mr.Floor AS Floor_number, mr.Room AS room_number, mr.did AS Department_ID, u.capacity AS Capacity
	FROM MeetingRooms mr, Updates u
	WHERE NOT EXISTS (SELECT sdate, stime
					FROM Sessions s
					WHERE Date = sdate
					AND stime BETWEEN Start_hour AND End_hour
					AND s.sfloor = mr.floor
					AND s.sroom = mr.room)
	AND u.floor = mr.floor
	AND u.room = mr.room
	ORDER BY u.capacity ASC;
	
$$ LANGUAGE sql;

/*---------------------------------------------------------*/

--book_room

CREATE OR REPLACE PROCEDURE book_room(floor_number INT, room_number INT, brdate DATE, Start_hour TIME,
									End_hour TIME, EmployeeID INT)
AS $$
DECLARE 
	curr_start_time TIME := Start_hour;
	temp INT:= 0;
BEGIN
/* exception case: booking timing exceeds one-hour duration */
	/* IF TIMEDIFF(CAST(Start_hour AS time),CAST(End_hour AS time)) > 1
	THEN RAISE EXCEPTION 'The input timings exceed one hour. Bookings can only be made in one hour intervals';
	END IF;  */

/* exception case: employee is a junior */
	IF NOT EXISTS(SELECT 1 from employees
				WHERE eid = EmployeeID
				AND (etype = 'Manager'
				OR etype = 'Senior')) 
				THEN RAISE EXCEPTION 'Current Employee does not have sufficient rights to book a room';
	END IF;
/* exception case: meeting room is already booked during stipulated timing*/
	IF EXISTS(SELECT 1 from Sessions s
			WHERE brdate = s.sdate
			AND s.sfloor = floor_number
			AND s.sroom = room_number
			AND s.stime BETWEEN Start_hour AND End_hour)
			THEN RAISE EXCEPTION 'Room has already been booked during that period. Please try another room or timing';
	END IF;
/* exception case: booker has already booked another room during stipulated timing*/
	IF EXISTS(SELECT 1 from Sessions s
			WHERE brdate = s.sdate
			AND s.bookerid = EmployeeID
			AND s.stime BETWEEN Start_hour AND End_hour)
			THEN RAISE EXCEPTION 'Booker has already made a booking for another room during that period. Please try another timing';
	END IF;
	 
	WHILE curr_start_time < End_hour LOOP
		INSERT INTO Sessions VALUES (brdate, curr_start_time, floor_number, room_number, EmployeeID, temp);
		curr_start_time := curr_start_time + interval '1 hour';
	END LOOP;

	CALL join_meeting(floor_number, room_number, brdate, Start_hour, End_hour, EmployeeID);

END;
$$ Language plpgsql;

/*---------------------------------------------------------*/

--unbook_room

CREATE OR REPLACE PROCEDURE unbook_room(floor_number INT, room_number INT, brdate DATE, Start_hour TIME, End_hour TIME, EmployeeID INT)
AS $$
/* DECLARE 
	curs CURSOR FOR (SELECT * FROM Joins
					WHERE sdate = brdate
					AND stime = Start_hour
					AND sfloor = floor_number
					AND sroom = room_number) ;
	r RECORD; */
DECLARE
	curr_start_time TIME := Start_hour;
BEGIN
	/*check if booking exists*/
	WHILE curr_start_time < End_hour LOOP
		IF NOT EXISTS (SELECT 1 FROM Sessions
				WHERE sdate = brdate
				AND stime = curr_start_time
				AND sfloor = floor_number
				AND sroom = room_number)
				THEN RAISE EXCEPTION 'There is no such session available.';
		END IF;
	/*Check if employee is the og booker*/
		IF EmployeeID <> (SELECT bookerid
						FROM Sessions 
						WHERE sdate = brdate
						AND stime = curr_start_time
						AND sfloor = floor_number
						AND sroom = room_number)
					THEN RAISE EXCEPTION 'Current employee did not make this booking. Please contact orginal booker.';
		END IF;
		curr_start_time := curr_start_time + interval '1 hour';
	END LOOP;
	/*check if meeting is approved -> remove approval*/
	/*loop through all participants to remove them*/
	curr_start_time := Start_hour;
	WHILE curr_start_time < End_hour LOOP
		DELETE FROM Joins 
		WHERE	sdate = brdate
				AND stime = curr_start_time
				AND sfloor = floor_number
				AND sroom = room_number ;
		/*finally delete session record*/
		DELETE FROM Sessions
		WHERE 	sdate = brdate
				AND stime = curr_start_time
				AND sfloor = floor_number
				AND sroom = room_number	;
		curr_start_time := curr_start_time + interval '1 hour';
	END LOOP;

END;
$$ Language plpgsql;

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

		SELECT u.capacity INTO cap FROM Updates u WHERE u.udate = (SELECT MAX(udate) FROM Updates WHERE room = mroom AND floor = mfloor AND udate <= mdate) AND room = mroom AND floor = mfloor;
        IF ((SELECT s.participants FROM Sessions s WHERE sdate = mdate AND stime = mshour AND sroom = mroom AND sfloor = mfloor) < cap) THEN
            WHILE temp < mehour LOOP
                INSERT INTO Joins
                VALUES (emp, mdate, temp, mfloor, mroom);
                
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
                AND stime = temp
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

-- employee must be a manager from the same department 
/*---------------------------------------------------------*/


/*---------------------------------------------------------*/
/* HEALTH */
/*---------------------------------------------------------*/
--declare_health

CREATE OR REPLACE PROCEDURE declare_health
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
		PERFORM contact_tracing(NEW.eid, NEW.ddate);
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
/*---------------------------------------------------------*/
/* ADMIN */
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

/*--------------------------------------------------*/

CREATE OR REPLACE FUNCTION view_future_meeting
(IN startDate DATE, IN EmployeeID INTEGER)
RETURNS TABLE(Floor_number INTEGER, Room_number INTEGER, Date DATE, Start_hour TIME) AS $$

	SELECT sfloor, sroom, sdate, stime
	FROM Sessions NATURAL JOIN Joins
	WHERE approval_status = 'approved'
	AND eid = EmployeeID
	AND sdate >= startDate
	ORDER BY sdate ASC, stime ASC;
$$ LANGUAGE sql;

/*--------------------------------------------------*/

CREATE OR REPLACE FUNCTION view_manager_report (startDate DATE, EmployeeID INT)
RETURNS TABLE(floor_number INT, room_number INT, booking_date DATE, Start_hour TIME, BookerID INT)
AS $$
BEGIN
	-- check employee access
	IF NOT EXISTS (SELECT 1 FROM Employees
					WHERE EmployeeID = eid
					AND etype = 'Manager')
					THEN RAISE EXCEPTION 'Boo hoo you are not a manager';
	END IF;
	
	RETURN QUERY 
		SELECT s.sfloor AS floor_number, s.sroom AS room_number, s.sdate AS booking_date, 
		s.stime AS Start_hour, s.bookerid AS BookerID
		FROM Sessions s, Employees e1, Employees e2  
		WHERE s.bookerid = e1.eid 
		AND EmployeeID = e2.eid
		AND e1.did = e2.did
		AND s.approval_status IS NULL
		AND s.sdate >= startDate
		ORDER BY s.sdate,s.stime ASC; 
	
END;
<<<<<<< Updated upstream
$$ Language plpgsql;

/*--------------------------------------------------*/

CREATE OR REPLACE PROCEDURE on_session_join
(IN jdate DATE, IN jtime TIME, IN jfloor INTEGER, IN jroom INTEGER)
AS $$
BEGIN
	UPDATE Sessions 
	SET participants = participants + 1
	WHERE sdate = jdate
	AND stime = jtime
	AND sfloor = jfloor
	AND sroom = jroom;
END;
$$ language plpgsql;

CREATE OR REPLACE PROCEDURE on_session_leave
(IN jdate DATE, IN jtime TIME, IN jfloor INTEGER, IN jroom INTEGER)
AS $$
BEGIN
	UPDATE Sessions 
	SET participants = participants - 1
	WHERE sdate = jdate
	AND stime = jtime
	AND sfloor = jfloor
	AND sroom = jroom;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION on_session_join_triggerfunc() RETURNS TRIGGER AS $$
BEGIN 
	CALL on_session_join(NEW.sdate, NEW.stime, NEW.sfloor, NEW.sroom);
	RETURN NULL;
END;
$$ language plpgsql;

CREATE TRIGGER participant_increment
AFTER INSERT ON Joins
FOR EACH ROW EXECUTE FUNCTION on_session_join_triggerfunc();

CREATE OR REPLACE FUNCTION on_session_leave_triggerfunc() RETURNS TRIGGER AS $$
BEGIN 
	CALL on_session_leave(OLD.sdate, OLD.stime, OLD.sfloor, OLD.sroom);
	RETURN NULL;
END;
$$ language plpgsql;

CREATE TRIGGER participant_decrement
AFTER DELETE ON Joins
FOR EACH ROW EXECUTE FUNCTION on_session_leave_triggerfunc();

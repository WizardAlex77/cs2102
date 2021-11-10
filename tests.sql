/* Function (1) add_department */
CALL add_department(11, 'Finance'); --expected to pass
CALL add_department(12, 'Agile Solutions'); --expected to pass
CALL add_department(1, 'Accounting'); --expected to fail; department already exists

/* Function (2) remove_department */
CALL remove_department(12, 1); --expected to pass, no employees moved
CALL remove_department(1, 11); --expected to pass, employees 1, 8, 12 moved to department 11
CALL remove_department(99, 2); --expected to fail, department does not exist

/* Function (3) add_room */
CALL add_room(3, 07, 'Production Meeting Room', 10, 5); --expected to pass
CALL add_room(1, 31, 'Finance Meeting Room', 15, 11); --expected to fail, room already exists
CALL add_room(5, 09, 'Discussion Room', 30, 77); --expected to fail, department does not exist

/* Function (4) change_capacity */
CALL change_capacity(3, 32, 5, '2021-11-21', 12); --expected to pass
CALL change_capacity(1, 31, 9, '2021-11-22', 13); --expected to pass
CALL change_capacity(1, 31, 5, '2021-11-22', 13); --expected to pass, same room updated on same day
CALL change_capacity(4, 18, 5, '2021-12-5', 12); --expected to fail, room does not exist
CALL change_capacity(2, 39, 5, '2021-12-5', 1); --expected to fail, employee is not MANAGER
CALL change_capacity(3, 26, 5, '2021-12-5', 99); --expected to fail, employee does not exist

/* Function (5) add_employee */
CALL add_employee('Sally Tan Hui Yun', 'Junior', 5, 91010101, null, 62020202); --expected to pass
CALL add_employee('Sally Tan', 'Junior', 9, 91010101, null, 62020202); --expected to fail; employee already exists
CALL add_employee('Gareth Koh', 'Junior', 10, 99998880, null, null); --expected to pass (although there is already a Gareth Koh)

/* Function (6) remove_employee */
CALL remove_employee(8, '2021-10-30'); --expected to pass
CALL remove_employee(99, '2021-11-2'); --expected to fail, employee does not exist

/* THIS IS A PLACEHOLDER 
Set 1: Verify that the function works in the normal case (Passing) 
CALL add_employee ('Grace', '98765432', 'Junior', 'Accounting')
CALL add_employee ('Natalie', '12345678', 'Manager', 'HR')
CALL add_employee ('Gareth', '99998888', 'Senior', 'Accounting')
CALL add_employee ('Kevin', '88889999', 'Junior', 'Marketing')
CALL add_employee ('Moose', '91111111', 'Manager', 'Marketing')

/* Set 2: 
    1. Verify that that function adds tuples to Health Declarations
    2. Fever dectector trigger detects temperature and changes fever attribute correctly
    3. Non-compliance function works
*/ 

/* Function (13) declare_health */
CALL declarehealth(1, '2021-10-20', 37.0); 
CALL declarehealth(1, '2021-10-21', 36.2);
CALL declarehealth(1, '2021-10-22', 36.9);
CALL declarehealth(2, '2021-10-20', 36.4);
CALL declarehealth(2, '2021-10-21', 35.2);
CALL declarehealth(3, '2021-10-20', 37.4);
CALL declarehealth(4, '2021-10-20', 37.1);
CALL declarehealth(4, '2021-10-21', 37.2);
CALL declarehealth(4, '2021-10-22', 38.1); -- should have fever reflected in Health Declarations ---> trigger working

/* Function (15) non-compliance */
SELECT * FROM non_compliance('2021-10-20', '2021-10-22'); -- should have (3,2) and (2,1)
SELECT * FROM non_compliance('2021-10-20', '2021-10-21'); -- should have (3,1)
SELECT * FROM non_compliance('2021-10-20', '2021-10-20'); -- empty

/* Set 3: Verify that contact_tracing correctly identifies only employees in same meeting room within past 3 days*/
INSERT INTO Sessions VALUES ('2021-10-23', '09:00:00' , 1 , 21 , 3, 2, 'approved'); -- Meeting A at (1,21) on the 23rd
INSERT INTO Sessions VALUES ('2021-10-25', '08:00:00' , 1 , 11 , 3, 2, 'approved'); -- Meeting B at (1,11) on the 25th
INSERT INTO Sessions VALUES ('2021-10-26', '09:00:00' , 1 , 21 , 3, 3, 'approved'); -- Meeting C at (1,21) on the 26rd

INSERT INTO JOINS VALUES (1, '2021-10-23', '09:00:00', 1, 21), (4, '2021-10-23', '09:00:00', 1, 21); -- Employee 1 & 4 at Meeting A
INSERT INTO JOINS VALUES (1, '2021-10-25', '08:00:00', 1, 11), (3, '2021-10-25', '08:00:00', 1, 11); -- Employee 1 & 3 at Meeting B
INSERT INTO JOINS VALUES (2, '2021-10-26', '09:00:00', 1, 21), (3, '2021-10-26', '09:00:00', 1, 21), (4, '2021-10-26', '09:00:00', 1, 21); -- Employee 2, 3 & 4 at Meeting C

SELECT * FROM contact_tracing(4, '2021-10-27'); -- 4 has fever on 27th, past 3 days (24th to 27th), only employees 2 & 3 from Meeting C affected
-- declarehealth(4, '2021-10-27', 38.0);
SELECT * FROM contact_tracing(4, '2021-10-26'); -- 4 has fever on 26th, past 3 days (23th to 26th), employees 1, 2 & 3 from Meeting A nd C affected 
-- declarehealth(4, '2021-10-26', 38.0);

/* Set 4: Verify that contact_tracing correctly removes fever and close-contact employees from future meetings*/
INSERT INTO Employees VALUES (5, 'Moose', 'moose@gmail.com', 'Manager', 4, 91111111); 

INSERT INTO Sessions VALUES ('2021-10-29', '09:00:00' , 4 , 11 , 4, 2, 'approved'); -- Meeting D at (4,11) on the 29th
INSERT INTO Sessions VALUES ('2021-10-30', '09:00:00' , 4 , 17 , 5, 3, 'approved'); -- Meeting E at (4,17) on the 30th
INSERT INTO Sessions VALUES ('2021-11-19', '09:00:00' , 4 , 34 , 5, 3, 'approved'); -- Meeting D at (4,34) on the 19th of NEXT month

INSERT INTO JOINS VALUES (4, '2021-10-29', '09:00:00', 4, 11), (5, '2021-10-29', '09:00:00', 4, 11); -- Employee 4 & 5 at Meeting D, 4 is booker of meeting
INSERT INTO JOINS VALUES (5, '2021-10-30', '09:00:00', 4, 17), (4, '2021-10-30', '09:00:00', 4, 17), (3, '2021-10-30', '09:00:00', 4, 17); -- Employee 3, 4 & 5 at Meeting E, 5 is booker of meeting
INSERT INTO JOINS VALUES (5, '2021-11-19', '09:00:00', 4, 34), (4, '2021-11-19', '09:00:00', 4, 34), (3, '2021-11-19', '09:00:00', 4, 34); -- Employee 3, 4 & 5 at Meeting F, 5 is booker of meeting

SELECT * FROM contact_tracing(4, '2021-10-27');
-- declarehealth(4, '2021-10-27', 38.0);
-- Will remove Meeting D completely (and its related tuples in Joins) due to 4 being booker of meeting
-- Will remove 3 & 4 from Meeting E, but 5 will still attend.
-- Removes 4 from Meeting F (one month away) since Employee 4 is the one with the fever, but not 3, since 3 close-contact is only 7 days in the future.

/* Set 5: Verify that view_booking_report works */
INSERT INTO Sessions VALUES ('2021-11-01', '09:00:00' , 4 , 34 , 5, 1, null);
INSERT INTO JOINS VALUES (5, '2021-11-01', '09:00:00', 4, 34);

SELECT * FROM view_booking_report('2021-10-22', 3); -- shows meeting A B and C as approved, sorted
SELECT * FROM view_booking_report('2021-10-30', 5); -- shows meeting on 11-01 as not approved, meeting on 10-30 and 11-19 as approved, sorted
SELECT * FROM view_booking_report('2021-11-05', 5); -- shows meeting on 19th as approved
SELECT * FROM view_booking_report('2021-11-20', 5); -- no meetings from this period onwards


/*join meeting*/ 
--join_meeting(mfloor INTEGER, mroom INTEGER, mdate DATE, mshour TIME, mehour TIME, emp INTEGER)

-- cannot join if already in
-- only can join meeting that has not been approved
-- meeting must not be over capacity
-- must add to Joins table
-- meeting must exist

/*----------------------------------------------------*/
/*leave_meeting*/
--leave_meeting(mfloor INTEGER, mroom INTEGER, mdate DATE, mshour TIME, mehour TIME, emp INTEGER)

-- cannot leave an approved meeting
-- must remove from joins table
-- meeting must exist and already part of it 

/*----------------------------------------------------*/

/*approve meeting*/
--approve_meeting(mfloor INTEGER, mroom INTEGER, mdate DATE, mshour TIME, mehour TIME, emp INTEGER, decision VARCHAR(10))

-- only can approve meeting in own department
-- should reflect 'approved' in sessions
-- should delete if rejected

/*----------------------------------------------------*/
-- these tests are run in this sequence
CALL join_meeting(2, 22,'2022-04-18', '08:00:00', '09:00:00', 2); -- unsuccessful cos already in
CALL join_meeting(2, 25,'2022-05-10', '09:00:00', '10:00:00', 4); -- unsuccessful cos approved alr
CALL join_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 4); -- successful
CALL join_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 4); -- unsuccessful cos alr in
CALL join_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 1); -- unsuccessful cos room full
CALL join_meeting(4, 11,'2022-05-10', '10:00:00', '11:00:00', 4); -- unsuccesful no such meeting
CALL join_meeting(4, 17,'2022-05-10', '09:00:00', '10:00:00', 3); -- unsuccessful cos alr in another meeting

CALL leave_meeting(2, 25,'2022-05-10', '09:00:00', '10:00:00', 3); -- unsuccessful cos alr approved
CALL leave_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 4); -- successful
CALL leave_meeting(4, 11,'2022-05-10', '10:00:00', '11:00:00', 4); -- unsuccessful no such meeting
CALL leave_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 4); -- unsuccessful not part of meeting
CALL leave_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 3); -- successful booker leave meeting

CALL approve_meeting(2, 22,'2022-04-18', '08:00:00', '09:00:00', 2, 'approved'); -- successful
CALL join_meeting(2, 22,'2022-04-18', '08:00:00', '09:00:00', 1); -- unsuccesful alr approved
CALL approve_meeting(4, 17,'2022-05-10', '09:00:00', '10:00:00', 2, 'approved'); -- unsuccessful cos not own dept
CALL approve_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 3, 'approved'); -- unsuccessful cos not a manager
CALL approve_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 2, 'rejected'); -- successful

CALL join_meeting(3, 11,'2022-10-29', '09:00:00', '12:00:00', 4); 
CALL leave_meeting(3, 11,'2022-10-29', '09:00:00', '12:00:00', 4);
CALL approve_meeting(3, 11,'2022-10-29', '09:00:00', '12:00:00', 2, 'approved');
CALL approve_meeting(3, 32,'2022-10-31', '11:00:00', '14:00:00', 5, 'rejected');


SELECT * FROM view_future_meeting(CAST('2022-04-10' AS DATE), 3);

/* Function (15) declare_health */
CALL declarehealth(4, '2021-10-16', 36.5); --expected to pass - correct
CALL declarehealth(5, '2021-10-16', 36.5); --expected to fail - correct

/* Function search_room */

SELECT * FROM search_room('2022-05-10', '09:00', '15:00'); --should return 12 rooms
SELECT * FROM search_room('2022-05-13', '09:00', '15:00'); --should return 14 rooms

CALL book_room(1, 11, '2022-05-10', '09:00', '10:00', 2); --expect to fail -- has booked another room during same timing
CALL book_room(2, 22, '2022-04-10', '08:00', '12:00', 2); -- expect to pass
CALL book_room(2, 22, '2022-04-12', '08:00', '12:00', 3); -- expect to pass
CALL book_room(2, 22, '2022-04-13', '08:00', '12:00', 1); -- expect to fail -- employee access error


CALL unbook_room(1, 11, '2022-05-10', '09:00', '10:00', 2); -- expect to fail - no such session avail
CALL unbook_room(2, 22, '2022-04-12', '08:00', '12:00', 2); -- expect to fail - not original booker
CALL unbook_room(2, 22, '2022-04-12', '08:00', '12:00', 3); -- expect to pass
CALL unbook_room(2, 22, '2022-04-10', '08:00', '12:00', 2); -- expect to pass 

SELECT * FROM view_manager_report('2022-04-10', 12); -- pass;should have 2 reports
SELECT * FROM view_manager_report('2022-04-11', 12); -- pass;should have 2 reports
SELECT * FROM view_manager_report('2022-05-10', 12); -- pass;should have 1 report
SELECT * FROM view_manager_report('2022-05-10', 13); -- fail;should throw employee error

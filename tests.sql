/* Function (1) add_department */
SELECT * FROM departments;
CALL add_department(11, 'Finance'); --expected to pass
CALL add_department(1, 'Accounting'); --expected to fail; department already exists

/* Function (2) remove_department */
SELECT * from employees;
SELECT * from meetingrooms;
CALL remove_department(1, 11); --expected to pass, employees 1, 8, 12 moved to department 11
CALL remove_department(99, 2); --expected to fail, department does not exist

/* Function (3) add_room */
SELECT * from meetingrooms;
SELECT * from updates;
CALL add_room(3, 07, 'Production Meeting Room', 10, 5); --expected to pass
CALL add_room(1, 31, 'Finance Meeting Room', 15, 11); --expected to fail, room already exists
CALL add_room(5, 09, 'Discussion Room', 30, 77); --expected to fail, department does not exist

/* Function (4) change_capacity */
SELECT * from updates;
CALL change_capacity(1, 31, 9, '2021-11-22', 13); --expected to pass
CALL change_capacity(1, 31, 5, '2021-11-22', 13); --expected to pass, same room updated on same day
CALL change_capacity(4, 18, 5, '2021-12-5', 12); --expected to fail, room does not exist
CALL change_capacity(2, 39, 5, '2021-12-5', 1); --expected to fail, employee is not MANAGER
CALL change_capacity(3, 26, 5, '2021-12-5', 99); --expected to fail, employee does not exist

/* Function (5) add_employee */
SELECT * FROM employees;
CALL add_employee('Sally Tan Hui Yun', 'Junior', 5, 91010101, null, 62020202); --expected to pass
CALL add_employee('Sally Tan', 'Junior', 9, 91010101, null, 62020202); --expected to fail; employee already exists
CALL add_employee('Gareth Koh', 'Junior', 10, 99998880, null, null); --expected to pass (although there is already a Gareth Koh)

/* Function (6) remove_employee */
CALL remove_employee(23, '2021-10-30'); --expected to pass
CALL remove_employee(99, '2021-11-2'); --expected to fail, employee does not exist

/* --------------------------------- refresh schema and data now ---------------------------- */

/* Function (7) search_room */
SELECT * FROM search_room('2022-05-10', '09:00', '15:00'); --should return 18 rooms /3-32 cap is 9
SELECT * FROM search_room('2022-05-13', '09:00', '15:00'); --should return 20 rooms /3-32 cap is 9
CALL change_capacity(3, 32, 5, '2022-05-12', 12); -- inbetween the two dates
SELECT * FROM search_room('2022-05-10', '09:00', '15:00'); --should return 18 rooms /3-32 cap is still 9
SELECT * FROM search_room('2022-05-13', '09:00', '15:00'); --should return 20 rooms /3-32 cap is now 5

/* Function (8) book_room */
/* CALL book_room(1, 11, '2022-05-10', '09:00', '10:00', 12); -- SKIP:expect to pass
SELECT * FROM Sessions WHERE sdate = '2022-05-10'; --SKIP
CALL book_room(2, 11, '2022-05-10', '09:00', '10:00', 12); --expect to fail -- booker has already booked another room at the same timing */
SELECT * FROM MeetingRooms;
CALL book_room(2, 22, '2022-04-10', '08:00', '12:00', 12); -- expect to fail -- meeting room does not exist - sql foreign key constraint check
SELECT * Employees;
CALL book_room(2, 21, '2022-04-13', '08:00', '12:00', 1); -- expect to fail -- employee access error
SELECT * FROM Sessions WHERE sdate = '2022-04-12';
CALL book_room(2, 21, '2022-04-12', '08:00', '12:00', 13); -- expect to pass -- able to add multiple sessions with time range
SELECT * FROM Sessions WHERE sdate = '2022-04-12'; -- to show that above works
CALL book_room(1, 21, '2022-04-12', '08:00', '12:00', 13); --expect to fail -- booker has already booked another room at the same timing

/* Function (9) unbook_room */
/* CALL unbook_room(1, 11, '2022-05-10', '09:00', '10:00', 12); -- expect to pass
CALL unbook_room(1, 11, '2022-05-10', '09:00', '10:00', 12); -- expect to fail - no such session available */
CALL unbook_room(2, 21, '2022-04-12', '08:00', '12:00', 12); -- expect to fail - not original booker
CALL unbook_room(2, 21, '2022-04-12', '08:00', '12:00', 13); -- expect to pass 
SELECT * FROM Sessions WHERE sdate = '2022-04-12'; -- to show that above works
CALL unbook_room(2, 21, '2022-04-12', '08:00', '12:00', 13); -- expect to fail - no such session exists

/* Function (18) view_manager_report */
SELECT * FROM Employees;
SELECT * FROM view_manager_report('2022-04-10', 12); -- pass;should have 7 reports
CALL book_room(1, 11, '2022-04-10', '14:00', '16:00', 8); 
SELECT * FROM view_manager_report('2022-04-10', 12); -- pass; 
/* SELECT * FROM view_manager_report('2022-04-10', 12); -- pass; should have 10 now 
SELECT * FROM view_manager_report('2022-04-11', 12); -- pass;should have 6 reports
SELECT * FROM view_manager_report('2022-05-10', 12); -- pass;should have 1 report */
SELECT * FROM view_manager_report('2022-04-10', 13); -- pass;different department manager
SELECT * FROM view_manager_report('2022-05-10', 3); -- fail;should throw employee error
/* --------------------------------- refresh schema and data now ---------------------------- */


/* Function (10) join_meeting */
CALL join_meeting(2, 21,'2022-04-10', '12:00:00', '13:00:00', 4); -- unsuccessful cos approved alr
CALL join_meeting(2, 21,'2022-04-10', '09:00:00', '10:00:00', 4); -- successful
SELECT * from sessions;
SELECT * from joins;
CALL join_meeting(2, 21,'2022-04-10', '09:00:00', '10:00:00', 1); -- unsuccessful cos room full

/* Function (11) leave_meeting */
CALL leave_meeting(2, 21,'2022-04-10', '12:00:00', '13:00:00', 8); -- unsuccessful cos alr approved
CALL leave_meeting(2, 21,'2022-04-10', '09:00:00', '10:00:00', 4); -- successful
SELECT * from sessions;
CALL leave_meeting(2, 21,'2022-04-10', '09:00:00', '10:00:00', 8); -- successful booker leave meeting
SELECT * from sessions;

/* Function (12) approve_meeting */
CALL approve_meeting(3, 11,'2022-10-29', '09:00:00', '12:00:00', 12, 'approved'); -- unsuccessful cos not own dept
CALL approve_meeting(3, 11,'2022-10-29', '09:00:00', '12:00:00', 11, 'approved'); -- unsuccessful cos not a manager
CALL approve_meeting(3, 11,'2022-10-29', '09:00:00', '12:00:00', 17, 'approved'); -- successful
CALL approve_meeting(3, 32,'2022-10-31', '11:00:00', '14:00:00', 18, 'rejected'); -- successful

/* Function (17) view_future_meeting */
-- set up to call view_future_meeting
CALL join_meeting(4, 11,'2022-05-10', '09:00:00', '10:00:00', 4);
CALL join_meeting(2, 34,'2022-04-18', '08:00:00', '09:00:00', 4);
CALL approve_meeting(4, 11,'2022-05-10', '09:00:00', '10:00:00', 19, 'approved');
CALL approve_meeting(2, 34,'2022-04-18', '08:00:00', '09:00:00', 15, 'approved'); -- employee 4 joins 2 meetings, and both are approved

SELECT * FROM view_future_meeting(CAST('2022-04-10' AS DATE), 4); -- should show 2 meetings




/* --------------------------------- refresh schema and data now ---------------------------- */

/* Set 4: 
    1. Verify that that function adds tuples to Health Declarations
    2. Fever dectector trigger detects temperature and changes fever attribute correctly
    3. Non-compliance function works
*/ 

 /* Function (13) declare_health */
SELECT * FROM HealthDeclarations;
CALL declare_health(1, '2022-11-08', 37.0); --employee 1 & 2 did not declare health on 2nd day
CALL declare_health(2, '2022-11-08', 37.0);
CALL declare_health(3, '2022-11-08', 37.0); 
CALL declare_health(3, '2022-11-09', 36.2);
CALL declare_health(4, '2022-11-08', 37.0); 
CALL declare_health(4, '2022-11-09', 36.2);
CALL declare_health(5, '2022-11-08', 37.0); 
CALL declare_health(5, '2022-11-09', 36.2);
CALL declare_health(6, '2022-11-08', 37.0); 
CALL declare_health(6, '2022-11-09', 36.2);
CALL declare_health(7, '2022-11-08', 37.0); 
CALL declare_health(7, '2022-11-09', 36.2);
CALL declare_health(8, '2022-11-08', 37.0); 
CALL declare_health(8, '2022-11-09', 36.2);
CALL declare_health(9, '2022-11-08', 37.0); 
CALL declare_health(9, '2022-11-09', 36.2);
CALL declare_health(10, '2022-11-08', 37.0); 
CALL declare_health(10, '2022-11-09', 36.2);
CALL declare_health(11, '2022-11-08', 37.0); 
CALL declare_health(11, '2022-11-09', 36.2);
CALL declare_health(12, '2022-11-08', 37.0); 
CALL declare_health(12, '2022-11-09', 36.2);
CALL declare_health(13, '2022-11-08', 37.0); 
CALL declare_health(13, '2022-11-09', 36.2);
CALL declare_health(14, '2022-11-08', 37.0); 
CALL declare_health(14, '2022-11-09', 36.2);
CALL declare_health(15, '2022-11-08', 37.0); 
CALL declare_health(15, '2022-11-09', 36.2);
CALL declare_health(16, '2022-11-08', 37.0); 
CALL declare_health(16, '2022-11-09', 36.2);
CALL declare_health(17, '2022-11-08', 37.0); 
CALL declare_health(17, '2022-11-09', 36.2);
CALL declare_health(18, '2022-11-08', 37.0); 
CALL declare_health(18, '2022-11-09', 36.2);
CALL declare_health(19, '2022-11-08', 37.0); 
CALL declare_health(19, '2022-11-09', 36.2);
CALL declare_health(20, '2022-11-08', 37.0); 
CALL declare_health(20, '2022-11-09', 36.2);
CALL declare_health(21, '2022-11-08', 38.0); --employee 21 has fever on this day
CALL declare_health(21, '2022-11-09', 36.2);
SELECT * FROM HealthDeclarations;



/* Function (15) non-compliance */
SELECT * FROM non_compliance('2022-11-08', '2022-11-09'); -- employee 1 and 2 should have 1 day of non-compliance
SELECT * FROM non_compliance('2022-11-08', '2022-11-08'); -- none, all employees declared health on that day

/* Function (14) contact_tracing: Verify that contact_tracing correctly identifies only employees in same meeting room within past 3 days*/
SELECT * FROM Sessions;
SELECT * FROM Joins;
CALL book_room(1, 21, '2022-11-23', '09:00:00' , '10:00:00', 8); -- Meeting A at (1,21) on the 23rd
CALL book_room(1, 11, '2022-11-25', '09:00:00' , '10:00:00', 12); -- Meeting B at (1,11) on the 25th
CALL book_room(1, 21, '2022-11-26', '09:00:00' , '10:00:00', 8); -- Meeting C at (1,21) on the 26rd

CALL join_meeting(1, 21, '2022-11-23', '09:00:00' , '10:00:00', 4); -- Employee 4 & 8 at Meeting A
CALL join_meeting(1, 11, '2022-11-25', '09:00:00' , '10:00:00', 3); -- Employee 3 & 12 at Meeting B
CALL join_meeting(1, 21, '2022-11-26', '09:00:00' , '10:00:00', 2); -- Employee 2, 3 & 8 at Meeting C
CALL join_meeting(1, 21, '2022-11-26', '09:00:00' , '10:00:00', 3);

CALL approve_meeting(1, 21, '2022-11-23', '09:00:00' , '10:00:00', 12, 'approved');
CALL approve_meeting(1, 11, '2022-11-25', '09:00:00' , '10:00:00', 12, 'approved');
CALL approve_meeting(1, 21, '2022-11-26', '09:00:00' , '10:00:00', 12, 'approved');

SELECT * FROM Sessions;
SELECT * FROM Joins;

SELECT * FROM contact_tracing(8, '2022-11-27'); -- 8 has fever on 27th, past 3 days (24th to 27th), only employees 2 & 3 from Meeting C affected
SELECT * FROM contact_tracing(8, '2022-11-26'); -- 4 has fever on 26th, past 3 days (23th to 26th), employees 2, 3 & 4 from Meeting A and C affected 

/*Verify that contact_tracing correctly removes fever and close-contact employees from future meetings*/
SELECT * FROM Sessions;
SELECT * FROM Joins;
CALL book_room(4, 11, '2022-11-29', '09:00:00' , '10:00:00', 8); -- Meeting D at (4,11) on the 29th
CALL book_room(4, 26, '2022-11-30', '09:00:00' , '10:00:00', 9); -- Meeting E at (4,17) on the 30th
CALL book_room(4, 11, '2022-12-10', '09:00:00' , '10:00:00', 9); -- Meeting F at (4,34) on the 10th of NEXT month

CALL join_meeting(4, 11, '2022-11-29', '09:00:00' , '10:00:00', 12);-- Employee 8 & 12 at Meeting D, 8 is booker of meeting
CALL join_meeting(4, 26, '2022-11-30', '09:00:00' , '10:00:00', 3); -- Employee 3, 8 & 9 at Meeting E, 9 is booker of meeting
CALL join_meeting(4, 26, '2022-11-30', '09:00:00' , '10:00:00', 8); 
CALL join_meeting(4, 11, '2022-12-10', '09:00:00' , '10:00:00', 3);  -- Employee 3, 8 & 9 at Meeting F, 9 is booker of meeting
CALL join_meeting(4, 11, '2022-12-10', '09:00:00' , '10:00:00', 8); 

CALL approve_meeting(4, 11, '2022-11-29', '09:00:00' , '10:00:00', 19, 'approved');
CALL approve_meeting(4, 26, '2022-11-30', '09:00:00' , '10:00:00', 19, 'approved');
CALL approve_meeting(4, 11, '2022-12-10', '09:00:00' , '10:00:00', 19, 'approved');

SELECT * FROM Sessions;
SELECT * FROM Joins;

SELECT * FROM contact_tracing(8, '2022-11-27');

SELECT * FROM Sessions;
SELECT * FROM Joins;
-- Will remove Meeting D completely (and its related tuples in Joins) due to 8 being booker of meeting
-- Will remove 3 & 8 from Meeting E, but 9 will still attend.
-- Removes 8 from Meeting F (one month away) since Employee 8 is the one with the fever, but not 3, since 3 close-contact is only 7 days in the future.

/* Function (16) view_booking_report: Verify that view_booking_report works */
SELECT * FROM Sessions;
SELECT * FROM view_booking_report('2022-11-29', 9); -- shows 2 meetings as approved

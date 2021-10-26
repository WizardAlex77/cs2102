/* Function (1) add_employee (Fabian) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_employee ('Grace', '98765432', 'Junior', 'Accounting')
CALL add_employee ('Natalie', '12345678', 'Manager', 'HR')
CALL add_employee ('Gareth', '99998888', 'Senior', 'Accounting')
CALL add_employee ('Kevin', '88889999', 'Junior', 'Marketing')

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
CALL approve_meeting(2, 23,'2022-04-10', '09:00:00', '10:00:00', 2, 'rejected'); -- successful (need to check)

/* Function (15) declare_health */
CALL declarehealth(4, '2021-10-16', 36.5); --expected to pass - correct
CALL declarehealth(5, '2021-10-16', 36.5); --expected to fail - correct


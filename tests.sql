/* Function (1) add_department */
CALL add_department(5, 'Marketing'); --expected to pass
CALL add_department(6, 'Operations'); --expected to pass
CALL add_department(1, 'Accounting'); --expected to fail; department already exists

/* Function (2) remove_department */
CALL remove_department(6, 1); --expected to pass, no employees moved
CALL remove_department(3, 5); --expected to pass
CALL remove_department(7, 2); --expected to fail, department does not exist

/* Function (3) add_room */
CALL add_room(5, 12, 'Marketing Meeting Room', 25, 5); --expected to pass
CALL add_room(1, 31, 'Finance Meeting Room', 15, 1); --expected to fail, room already exists
CALL add_room(5, 09, 'Discussion Room', 30, 6); --expected to fail, department does not exist

/* Function (4) change_capacity */
CALL change_capacity(5, 12, 55, '2021-11-2 16:30:00', 12); --expected to pass
CALL change_capacity(1, 11, 15, '2021-11-2 16:46:11', 15); --expected to pass
CALL change_capacity(4, 18, 40, '2021-11-2 16:46:55', 12); --expected to fail, room does not exist
CALL change_capacity(2, 22, 18, '2021-11-2 16:36:00', 1); --expected to fail, employee is not MANAGER
CALL change_capacity(3, 26, 20, '2021-11-2 16:37:00', 99); --expected to fail, employee does not exist

/* Function (5) add_employee */
CALL add_employee('Sally Tan Hui Yun', 'Junior', 5, 91010101, null, 62020202); --expected to pass
CALL add_employee('Lim Jun Jie', 'Senior', 4, 90123456, 65432109, null); --expected to pass
CALL add_employee('Sally Tan', 'Junior', 4, 91010101, null, 62020202); --expected to fail; employee already exists
CALL add_employee('Gareth Koh', 'Junior', 1, 99998880, null, null); --expected to pass (although there is already a Gareth Koh)

/* Function (6) remove_employee */
CALL remove_employee(18, '2021-11-2'); --expected to pass
CALL remove_employee(99, '2021-11-2'); --expected to fail, employee does not exist

/* Function (15) declare_health */
CALL declarehealth(4, '2021-10-16', 36.5); --expected to pass - correct
CALL declarehealth(5, '2021-10-16', 36.5); --expected to fail - correct


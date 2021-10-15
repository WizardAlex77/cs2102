/* Function (1) add_employee (Fabian) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_employee ('Grace', '98765432', 'Junior', 'Accounting')
CALL add_employee ('Natalie', '12345678', 'Manager', 'HR')
CALL add_employee ('Gareth', '99998888', 'Senior', 'Accounting')
CALL add_employee ('Kevin', '88889999', 'Junior', 'Marketing')

/* Function (15) declare_health */
CALL declarehealth(4, '2021-10-16', 36.5); --expected to pass - correct
CALL declarehealth(5, '2021-10-16', 36.5); --expected to fail - correct


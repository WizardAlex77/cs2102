INSERT INTO Departments VALUES (1, 'Accounting'), (2, 'Human Resources'), (3, 'Marketing'), (4, 'Integrated IT'), 
(5, 'Production'), (6, 'Global Business Solutions'), (7, 'R&D'), (8, 'Digital Media'), (9, 'Procurement'), (10, 'Logistics');

/*---------------------------------------------------------*/

-- JUNIOR EMPLOYEES
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Grace Li', 'graceli_1@company.com', 'Junior', 1, 98765432);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Kevin Quek', 'kevinquek_2@company.com', 'Junior', 2, 88889999, 65553922);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Ravi Kumar', 'ravikumar_3@company.com', 'Junior', 3, 92424312);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Lucy Liu', 'lucyliu_4@company.com', 'Junior', 4, 89024951, 69750864);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Nico Williams', 'nicowilliams_5@company.com', 'Junior', 5, 88370183);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Francis Tan Wei Jie', 'francistanweijie_6@company.com', 'Junior', 6, 91047205);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Lucas Hwang', 'lucashwang_7@company.com', 'Junior', 7, 92119942, 64564567);

--SENIOR EMPLOYEES
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Gareth Koh', 'garethkoh_8@company.com','Senior', 1, 99998888, 67771111);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Daphne Chua', 'daphnechua_9@company.com','Senior', 2, 90001421, 60293333);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Kailash Grewal', 'kailashgrewal_10@company.com', 'Senior', 3, 92045667);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Rajab bin Razeen', 'rajabbinrazeen_11@company.com', 'Senior', 4, 89204819, 61123345);

-- MANAGER EMPLOYEES
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num, hp_num) VALUES ('Natalie Gordon', 'nataliegordon_12@company.com', 'Manager', 1, 92345678, 67771111, 60992221);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Esther Bell', 'estherbell_13@company.com', 'Manager', 2, 87653456, 65553922);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num, hp_num) VALUES ('Chan Yu Xin', 'chanyuxin_14@company.com', 'Manager', 3, 96745221, 63312254, 61123009);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Diti Sankar', 'ditisankar_15@company.com', 'Manager', 4, 91914081, 60090002);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Raita binti Furqaan', 'raitabintifurqaan_16@company.com', 'Manager', 5, 90665883, 60247392);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num, hp_num) VALUES ('Tan Jinjing', 'tanjinjing_17@company.com', 'Manager', 6, 80001235, 69373017, 61139261);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Jackson Wang', 'jacksonwang_18@company.com', 'Manager', 7, 84335566, 60938299);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Jennie Kim', 'jenniekim_19@company.com', 'Manager', 8, 98890989, 68820033);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Simu Liu', 'simuliu_20@company.com', 'Manager', 9, 91122112, 62219427);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Karina Yoo', 'karinayoo_21@company.com', 'Manager', 10, 94438859, 65935572);

/*---------------------------------------------------------*/

-- ACCOUNTING MEETING ROOMS
insert into MeetingRooms values (1, 11, 'Reception Room', 1);
insert into Updates values ('2021-10-1', 1, 11, 10);
insert into MeetingRooms values (1, 21, 'Conferencing Room', 1);
insert into Updates values ('2021-10-1', 1, 21, 20);

-- HUMAN RESOURCES MEETING ROOMS
insert into MeetingRooms values (1, 31, 'HR Meeting Room', 2);
insert into Updates values ('2021-10-1', 1, 31, 15);

-- ADVERTISING MEETING ROOMS
insert into MeetingRooms values (2, 17, 'Marketing Specialists Room', 3);
insert into Updates values ('2021-10-1', 2, 17, 20);

-- INTEGRATED IT MEETING ROOMS
insert into MeetingRooms values (2, 21, 'Database Meeting Room', 4);
insert into Updates values ('2021-10-1', 2, 21, 40);
insert into MeetingRooms values (2, 23, 'Database Meeting Room', 4);
insert into Updates values ('2021-10-1', 2, 23, 30);
insert into MeetingRooms values (2, 34, 'Auditorium', 4);
insert into Updates values ('2021-10-1', 2, 34, 32);

-- PRODUCTION MEETING ROOMS
insert into MeetingRooms values (2, 39, 'Production Room', 5);
insert into Updates values ('2021-10-1', 2, 39, 15);
insert into MeetingRooms values (3, 09, 'Videoconferencing Room', 5);
insert into Updates values ('2021-10-1', 3, 09, 30);

-- GLOBAL BUSINESS MEETING ROOMS
insert into MeetingRooms values (3, 11, 'Specialists Meeting Room', 6);
insert into Updates values ('2021-10-1', 3, 11, 15);
insert into MeetingRooms values (3, 14, 'Reception Room', 6);
insert into Updates values ('2021-10-1', 3, 14, 10);

-- R&D MEETING ROOMS
insert into MeetingRooms values (3, 26, 'R&D Meeting Room', 7);
insert into Updates values ('2021-10-1', 3, 26, 16);
insert into MeetingRooms values (3, 32, 'Hollow Square Room', 7);
insert into Updates values ('2021-10-1', 3, 32, 9);
insert into MeetingRooms values (4, 02, 'Research Room', 7);
insert into Updates values ('2021-10-1', 4, 02, 30);

-- DIGITAL MEDIA MEETING ROOMS
insert into MeetingRooms values (4, 11, 'Media Room', 8);
insert into Updates values ('2021-10-1', 4, 11, 20);
insert into MeetingRooms values (4, 15, 'Digital Media Experts Room', 8);
insert into Updates values ('2021-10-1', 4, 15, 9);
insert into MeetingRooms values (4, 26, 'Specialists Meeting Room', 8);
insert into Updates values ('2021-10-1', 4, 26, 16);

-- PROCUREMENT MEETING ROOMS
insert into MeetingRooms values (4, 30, 'Procurement Meeting Room', 9);
insert into Updates values ('2021-10-1', 4, 30, 15);

-- LOGISTICS MEETING ROOMS
insert into MeetingRooms values (5, 03, 'Logistics Room', 10);
insert into Updates values ('2021-10-1', 5, 03, 10);
insert into MeetingRooms values (5, 04, 'Assembly Room', 10);
insert into Updates values ('2021-10-1', 5, 04, 40);

-- UPDATED ROOM CAPACITIES IN LINE WITH SG GOVT COVID-19 RESTRICTIONS (as of 1 Nov 2021); ie. room with small capacity for testing purposes
insert into Updates values ('2021-11-1', 1, 11, 2); --#01-11, department 1
insert into Updates values ('2021-11-1', 1, 31, 4); --#01-31, department 2
insert into Updates values ('2021-11-1', 2, 21, 2); --#02-21, department 4
insert into Updates values ('2021-11-1', 2, 39, 4); --#02-39, department 5
insert into Updates values ('2021-11-1', 4, 15, 2); --#-4-15, department 8

/*---------------------------------------------------------*/


INSERT INTO Sessions VALUES ('2022-04-18', '08:00:00' , 2 , 22 , 2, 1, NULL); -- HR conferencing room
INSERT INTO Sessions VALUES ('2022-04-10', '09:00:00' , 2 , 23 , 3, 1, NULL); -- HR private room
INSERT INTO Sessions VALUES ('2022-05-10', '09:00:00' , 2 , 25 , 3, 1, 'approved'); -- Videoconferencing Room
INSERT INTO Sessions VALUES ('2022-05-10', '09:00:00' , 4 , 17 , 2, 1, NULL);
INSERT INTO Sessions VALUES ('2022-05-10', '10:00:00' , 2 , 25 , 3, 1, 'approved');
INSERT INTO Sessions VALUES ('2022-04-10', '12:00:00' , 2 , 23 , 3, 1, 'approved');

-- long sessions
INSERT INTO Sessions VALUES ('2022-10-29', '09:00:00' , 3 , 11 , 3, 1, NULL); -- HR Room
INSERT INTO Sessions VALUES ('2022-10-29', '10:00:00' , 3 , 11 , 3, 1, NULL);
INSERT INTO Sessions VALUES ('2022-10-29', '11:00:00' , 3 , 11 , 3, 1, NULL);

INSERT INTO Sessions VALUES ('2022-10-31', '11:00:00' , 3 , 32 , 3, 1, NULL); -- Marketing room
INSERT INTO Sessions VALUES ('2022-10-31', '12:00:00' , 3 , 32 , 3, 1, NULL);
INSERT INTO Sessions VALUES ('2022-10-31', '13:00:00' , 3 , 32 , 3, 1, NULL);


INSERT INTO Joins VALUES(2,'2022-04-18', '08:00:00', 2, 22); -- to simulate initial booking of HR conferencing room
INSERT INTO Joins VALUES(3,'2022-04-10', '09:00:00', 2, 23); -- to simulate initial booking of HR private room
INSERT INTO Joins VALUES(3,'2022-05-10', '09:00:00', 2, 25); -- to simulate initial booking of Videoconferencing Room
INSERT INTO Joins VALUES(2,'2022-05-10', '09:00:00', 4, 17);
INSERT INTO Joins VALUES(3,'2022-05-10', '10:00:00', 2, 25);
INSERT INTO Joins VALUES(3,'2022-04-10', '12:00:00', 2, 23);

-- join long sessions
INSERT INTO Joins VALUES(3,'2022-10-29', '09:00:00', 3, 11);
INSERT INTO Joins VALUES(3,'2022-10-29', '10:00:00', 3, 11);
INSERT INTO Joins VALUES(3,'2022-10-29', '11:00:00', 3, 11);

INSERT INTO Joins VALUES(3,'2022-10-31', '11:00:00', 3, 32);
INSERT INTO Joins VALUES(3,'2022-10-31', '12:00:00', 3, 32);
INSERT INTO Joins VALUES(3,'2022-10-31', '13:00:00', 3, 32);

--Healthdeclarations
INSERT INTO HealthDeclarations VALUES('2021-10-31', 1, 37.6, true); --employee 1 with fever
INSERT INTO HealthDeclarations VALUES('2021-10-31', 2, 35.5, false);
INSERT INTO HealthDeclarations VALUES('2021-10-31', 4, 36.4, false);
INSERT INTO HealthDeclarations VALUES('2021-10-31', 6, 36.9, false);
INSERT INTO HealthDeclarations VALUES('2021-10-31', 15, 35.6, false);
INSERT INTO HealthDeclarations VALUES('2021-10-31', 12, 35.7, false);
INSERT INTO HealthDeclarations VALUES('2021-11-01', 1, 38.5, true); --employee 1 with fever
INSERT INTO HealthDeclarations VALUES('2021-11-01', 15, 35.4, false);
INSERT INTO HealthDeclarations VALUES('2021-11-01', 12, 35.9, false);
INSERT INTO HealthDeclarations VALUES('2021-11-02', 1, 35.5, false); --employee 1 no longer has fever
INSERT INTO HealthDeclarations VALUES('2021-11-02', 2, 35.4, false);
INSERT INTO HealthDeclarations VALUES('2021-11-02', 4, 36.3, false);
INSERT INTO HealthDeclarations VALUES('2021-11-02', 6, 36.1, false);
INSERT INTO HealthDeclarations VALUES('2021-11-02', 15, 35.1, false);
INSERT INTO HealthDeclarations VALUES('2021-11-02', 12, 35.3, false);


INSERT INTO HealthDeclarations VALUES('2022-10-31', 1, 36.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 2, 37.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 3, 36.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 4, 35.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 5, 36.3, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 6, 36.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 7, 37.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 8, 36.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 9, 35.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 10, 36.3, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 11, 36.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 12, 37.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 13, 36.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 14, 35.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 15, 36.3, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 16, 36.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 17, 37.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 18, 36.0, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 19, 35.5, false);
INSERT INTO HealthDeclarations VALUES('2022-10-31', 20, 36.3, false);

INSERT INTO Departments VALUES (1, 'Accounting'), (2, 'Human Resources'), (3, 'Advertising'), (4, 'Technology and Equipment');

-- JUNIOR EMPLOYEES
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Grace Li', 'graceli_1@company.com', 'Junior', 1, 98765432);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Kevin Quek', 'kevinquek_2@company.com', 'Junior', 1, 88889999, 65553922);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Ravi Kumar', 'ravikumar_3@company.com', 'Junior', 2, 92424312);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Lucy Liu', 'lucyliu_4@company.com', 'Junior', 2, 89024951, 69750864);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Nico Williams', 'nicowilliams_5@company.com', 'Junior', 3, 88370183);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Francis Tan Wei Jie', 'francistanweijie_6@company.com', 'Junior', 4, 91047205);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Lucas Hwang', 'lucashwang_7@company.com', 'Junior', 4, 92119942, 64564567);

--SENIOR EMPLOYEES
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Gareth Koh', 'garethkoh_8@company.com','Senior', 1, 99998888);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Daphne Chua', 'daphnechua_9@company.com','Senior', 2, 90001421, 60293333);
INSERT INTO Employees (ename, email, etype, did, mp_num) VALUES ('Kailash Grewal', 'kailashgrewal_10@company.com', 'Senior', 3, 92045667);
INSERT INTO Employees (ename, email, etype, did, mp_num, hp_num) VALUES ('Rajab bin Razeen', 'rajabbinrazeen_11@company.com', 'Senior', 4, 89204819, 61123345);

-- MANAGER EMPLOYEES
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num, hp_num) VALUES ('Natalie Gordon', 'nataliegordon_12@company.com', 'Manager', 1, 92345678, 67771111, 60992221);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Esther Bell', 'estherbell_13@company.com', 'Manager', 2, 87653456, 68820011);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num, hp_num) VALUES ('Chan Yu Xin', 'chanyuxin_14@company.com', 'Manager', 3, 96745221, 63312254, 61123009);
INSERT INTO Employees (ename, email, etype, did, mp_num, op_num) VALUES ('Diti Sankar', 'ditisankar_15@company.com', 'Manager', 4, 91914081, 60090002);


-- ACCOUNTING MEETING ROOMS
insert into MeetingRooms values (1, 11, 'Reception Room', 1);
insert into Updates (floor, room, capacity) values (1, 11, 10);
insert into MeetingRooms values (1, 21, 'Conferencing Room', 1);
insert into Updates (floor, room, capacity) values (1, 21, 20);
insert into MeetingRooms values (1, 31, 'Finance Meeting Room', 1);
insert into Updates (floor, room, capacity) values (1, 31, 15);
insert into MeetingRooms values (2, 13, 'Auditorium', 1);
insert into Updates (floor, room, capacity) values (2, 13, 100);

-- HUMAN RESOURCES MEETING ROOMS
insert into MeetingRooms values (2, 22, 'HR Conferencing Room', 2);
insert into Updates (floor, room, capacity) values (2, 22, 20);
insert into MeetingRooms values (2, 23, 'HR private room', 2); -- room with small capacity for testing purposes
insert into Updates (floor, room, capacity) values (2, 23, 2);
insert into MeetingRooms values (2, 25, 'Videoconferencing Room', 2);
insert into Updates (floor, room, capacity) values (2, 25, 30);
insert into MeetingRooms values (3, 11, 'Specialists Meeting Room', 2);
insert into Updates (floor, room, capacity) values (3, 11, 15);
insert into MeetingRooms values (3, 14, 'Reception Room', 2);
insert into Updates (floor, room, capacity) values (3, 14, 10);

-- MARKETING MEETING ROOMS
insert into MeetingRooms values (3, 26, 'Specialists Meeting Room', 3);
insert into Updates (floor, room, capacity) values (3, 26, 16);
insert into MeetingRooms values (3, 32, 'Hollow Square Room', 3);
insert into Updates (floor, room, capacity) values (3, 32, 9);

-- IT MEETING ROOMS
insert into MeetingRooms values (4, 11, 'Database Meeting Room', 4);
insert into Updates (floor, room, capacity) values (4, 11, 40);
insert into MeetingRooms values (4, 17, 'Database Meeting Room', 4);
insert into Updates (floor, room, capacity) values (4, 17, 30);
insert into MeetingRooms values (4, 34, 'Videoconferencing Room', 4);
insert into Updates (floor, room, capacity) values (4, 34, 32);

INSERT INTO Sessions VALUES ('2022-04-18', '08:00:00' , 2 , 22 , 2, 1, NULL); -- HR conferencing room
INSERT INTO Sessions VALUES ('2022-04-10', '09:00:00' , 2 , 23 , 3, 1, NULL); -- HR private room
INSERT INTO Sessions VALUES ('2022-05-10', '09:00:00' , 2 , 25 , 3, 1, 'approved'); -- Videoconferencing Room

INSERT INTO Joins VALUES(2,'2022-04-18', '08:00:00', 2, 22); -- to simulate initial booking of HR conferencing room
INSERT INTO Joins VALUES(3,'2022-04-10', '09:00:00', 2, 23); -- to simulate initial booking of HR private room
INSERT INTO Joins VALUES(3,'2022-05-10', '09:00:00', 2, 25); -- to simulate initial booking of Videoconferencing Room

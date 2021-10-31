INSERT INTO Departments VALUES (1, 'Accounting'), (2, 'Human Resources'), (3, 'Marketing'), (4, 'Technology and Equipment');

INSERT INTO Employees VALUES (1, 'Grace', 'grace@gmail.com', 'Junior', 1, 98765432);
INSERT INTO Employees VALUES (2, 'Natalie', 'natalie@gmail.com', 'Manager', 2, 12345678);
INSERT INTO Employees VALUES (3, 'Gareth', 'gareth@gmail.com','Senior', 1, 99998888);
INSERT INTO Employees VALUES (4, 'Kevin', 'kevin@gmail.com', 'Junior', 3, 88889999);
INSERT INTO Employees VALUES (5, 'Goose', 'goose@gmail.com', 'Manager', 3, 91121111);


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
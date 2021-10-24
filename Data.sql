INSERT INTO Departments VALUES (1, 'Accounting'), (2, 'Human Resources'), (3, 'Marketing'), (4, 'Technology and Equipment');

INSERT INTO Employees VALUES (1, 'Grace', 'grace@gmail.com', 'Junior', 1, 98765432);
INSERT INTO Employees VALUES (2, 'Natalie', 'natalie@gmail.com', 'Manager', 2, 12345678);
INSERT INTO Employees VALUES (3,'Gareth', 'gareth@gmail.com','Senior', 1, 99998888,);
INSERT INTO Employees VALUES (4, 'Kevin', 'kevin@gmail.com', 'Junior', 3, 88889999);


-- ACCOUNTING MEETING ROOMS
insert into MeetingRooms values (11, 1, 'Reception Room', 1);
insert into MeetingRooms values (21, 1, 'Conferencing Room', 1);
insert into MeetingRooms values (31, 1, 'Finance Meeting Room', 1);
insert into MeetingRooms values (13, 2, 'Auditorium', 1);

-- HUMAN RESOURCES MEETING ROOMS
insert into MeetingRooms values (22, 2, 'HR Conferencing Room', 2);
insert into MeetingRooms values (25, 2, 'Videoconferencing Room', 2);
insert into MeetingRooms values (11, 3, 'Specialists Meeting Room', 2);
insert into MeetingRooms values (14, 3, 'Reception Room', 2);

-- MARKETING MEETING ROOMS
insert into MeetingRooms values (26, 3, 'Specialists Meeting Room', 3);
insert into MeetingRooms values (32, 3, 'Hollow Square Room', 3);

-- IT MEETING ROOMS
insert into MeetingRooms values (11, 4, 'Database Meeting Room', 4);
insert into MeetingRooms values (17, 4, 'Database Meeting Room', 4);
insert into MeetingRooms values (34, 4, 'Videoconferencing Room', 4);
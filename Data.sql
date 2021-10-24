INSERT INTO Departments VALUES (1, 'Accounting'), (2, 'Human Resources'), (3, 'Marketing'), (4, 'Technology and Equipment');

INSERT INTO Employees VALUES (1, 'Grace', 'grace@gmail.com', 'Junior', 1, 98765432);
INSERT INTO Employees VALUES (2, 'Natalie', 'natalie@gmail.com', 'Manager', 2, 12345678);
INSERT INTO Employees VALUES (3, 'Gareth', 'gareth@gmail.com','Senior', 1, 99998888);
INSERT INTO Employees VALUES (4, 'Kevin', 'kevin@gmail.com', 'Junior', 3, 88889999);


-- ACCOUNTING MEETING ROOMS
insert into MeetingRooms values (1, 11, 'Reception Room', 10, 1);
insert into MeetingRooms values (1, 21, 'Conferencing Room', 20, 1);
insert into MeetingRooms values (1, 31, 'Finance Meeting Room', 15, 1);
insert into MeetingRooms values (2, 13, 'Auditorium', 100, 1);

-- HUMAN RESOURCES MEETING ROOMS
insert into MeetingRooms values (2, 22, 'HR Conferencing Room', 20, 2);
insert into MeetingRooms values (2, 25, 'Videoconferencing Room', 30, 2);
insert into MeetingRooms values (3, 11, 'Specialists Meeting Room', 15, 2);
insert into MeetingRooms values (3, 14, 'Reception Room', 10, 2);

-- MARKETING MEETING ROOMS
insert into MeetingRooms values (3, 26, 'Specialists Meeting Room', 16, 3);
insert into MeetingRooms values (3, 32, 'Hollow Square Room', 9, 3);

-- IT MEETING ROOMS
insert into MeetingRooms values (4, 11, 'Database Meeting Room', 40, 4);
insert into MeetingRooms values (4, 17, 'Database Meeting Room', 30, 4);
insert into MeetingRooms values (4, 34, 'Videoconferencing Room', 32, 4);
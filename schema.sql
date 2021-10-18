CREATE TABLE Departments (
    did INTEGER PRIMARY KEY,
    dname VARCHAR(255) NOT NULL
);

/*---------------------------------------------------------*/

CREATE TABLE Employees (
    eid INTEGER PRIMARY KEY,
    ename VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    etype VARCHAR(10) NOT NULL,
    did INTEGER NOT NULL,
    mp_num INTEGER,
    op_num INTEGER,
    hp_num INTEGER,
    resignation_date DATE,
    CONSTRAINT etype_constraint CHECK(etype IN ('Junior', 'Senior', 'Manager')),
    CONSTRAINT department_constraint FOREIGN KEY (did) REFERENCES Departments (did)
); 

--No seperate table for (Works In), merged in Employees instead.


/*---------------------------------------------------------*/

CREATE TABLE HealthDeclarations (
    ddate DATE NOT NULL,
    eid INTEGER NOT NULL,
    temp NUMERIC(3, 1) NOT NULL,
    fever BOOLEAN NOT NULL, 
    PRIMARY KEY (ddate, eid),
    CONSTRAINT eid_constraint FOREIGN KEY (eid) REFERENCES Employees (eid)
);

--fever is a derived attribute, can be done using triggers

/*---------------------------------------------------------*/

CREATE TABLE MeetingRooms (
    room INTEGER NOT NULL,
    floor INTEGER NOT NULL,
    rname VARCHAR(255) NOT NULL,
    did INTEGER NOT NULL,
    PRIMARY KEY (room, floor),
    CONSTRAINT did_constraint FOREIGN KEY (did) REFERENCES Departments (did)
);

--capacity is done in Updates instead (model ER answer)
--maybe each room can be assigned unique id with triggers (for easier reference)

/*---------------------------------------------------------*/

CREATE TABLE Sessions (
    sdate DATE NOT NULL,
    stime TIME NOT NULL,
    sroom INTEGER NOT NULL,
    sfloor INTEGER NOT NULL,
    bookerid INTEGER NOT NULL, 
    approval_status VARCHAR(10),
    PRIMARY KEY (sdate, stime, sroom, sfloor),
    CONSTRAINT meetingroom_constraint FOREIGN KEY (sroom, sfloor) REFERENCES MeetingRooms (room, floor),
    CONSTRAINT booker_constraint FOREIGN KEY (bookerid) REFERENCES Employees (eid)
);

--maybe can have session id easier, generated using triggers
--time can be done with INTEGER using CHECK(stime >=0 AND stime <= 24)
--employee type (of main booker) is done during function call to book_room

/*---------------------------------------------------------*/

CREATE TABLE Joins (
    eid INTEGER NOT NULL,
    sdate DATE NOT NULL,
    stime TIME NOT NULL,
    sroom INTEGER NOT NULL,
    sfloor INTEGER NOT NULL,
    PRIMARY KEY (eid, sdate, stime),
    CONSTRAINT session_constraint FOREIGN KEY (sdate, stime, sroom, sfloor) REFERENCES Sessions (sdate, stime, sroom, sfloor),
    CONSTRAINT eid_constraint FOREIGN KEY (eid) REFERENCES Employees (eid)
);

/*---------------------------------------------------------*/


--either use approval status in Sessions or implement this table
--use triggers for approval, if not approved then delete, else disallow joining

/*---------------------------------------------------------*/

CREATE TABLE Updates (
    udate DATE NOT NULL,
    room INTEGER NOT NULL,
    floor INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    PRIMARY KEY (udate, room, floor),
    CONSTRAINT meetingroom_constraint FOREIGN KEY (room, floor) REFERENCES MeetingRooms (room, floor)
);

--Assume that only 1 entry for a particular date and meeting room. Any subsequent updates to this room on the same date just
--updates this entry.

/*---------------------------------------------------------*/

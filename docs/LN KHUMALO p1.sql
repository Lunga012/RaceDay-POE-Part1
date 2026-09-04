CREATE TABLE Role (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName VARCHAR(50) NOT NULL
);

CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(75) NOT NULL,
    RoleID INT NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

CREATE TABLE Event (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(150),
    Date DATE NOT NULL,
    Location VARCHAR(100),
    Distance DECIMAL(5,2),
    Type VARCHAR(20),
    OrganiserID INT NOT NULL,
    FOREIGN KEY (OrganiserID) REFERENCES [User](UserID)
);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    EventID INT NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(150),
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

CREATE TABLE Enrolment (
    EnrolmentID INT PRIMARY KEY IDENTITY(1,1),
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    ParticipantID INT NOT NULL,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (ParticipantID) REFERENCES [User](UserID)
);

CREATE TABLE Result (
    ResultID INT PRIMARY KEY IDENTITY(1,1),
    EnrolmentID INT NOT NULL,
    FinishTime TIME,
    Position INT,
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolment(EnrolmentID)
);

-- Sample Data
INSERT INTO Role (RoleName) VALUES ('Organiser'), ('Participant');

INSERT INTO [User] (Name, Email, PasswordHash, RoleID)
VALUES ('Lunga Organiser', 'khumalolungsta121@gmail.com', 'hashed123', 1),
       ('Njabulo Organiser', 'st10483560rcconnect.edu.za', 'hashed456', 1),
       ('Sphe Participant', 'sihles622@gmail.com', 'hashed789', 2),
       ('Sihle Participant', 'lungi@walk.com', 'hashed321', 2);

INSERT INTO Event (Name, Description, Date, Location, Distance, Type, OrganiserID)
VALUES ('Comrades Marathon', 'Ultra run', '2026-06-01', 'Durban', 89.0, 'Run', 1),
       ('Cape Town Cycle Tour', 'Cycling event', '2026-03-10', 'Cape Town', 109.0, 'Cycle', 2),
       ('Soweto Marathon', 'Community run', '2026-11-05', 'Soweto', 42.2, 'Run', 1);

INSERT INTO Category (EventID, Name, Description)
VALUES (1, 'Senior', 'Over 20 years'),
       (1, 'Junior', 'Under 20 years'),
       (2, 'Elite', 'Professional cyclists'),
       (2, 'Open', 'All participants'),
       (3, '10km', 'Short distance'),
       (3, '21km', 'Half marathon');

INSERT INTO Enrolment (EventID, CategoryID, ParticipantID, Status)
VALUES (1, 1, 3, 'Confirmed'),
       (2, 3, 4, 'Pending'),
       (3, 5, 3, 'Confirmed');

INSERT INTO Result (EnrolmentID, FinishTime, Position)
VALUES (1, '06:45:00', 47),
       (3, '01:15:00', 12);

-- Master Query ued to display
SELECT 
    Org.Name AS OrganiserName,
    P.Name AS ParticipantName,
    E.Name AS EventName,
    E.Date AS EventDate,
    C.Name AS CategoryName,
    En.Status AS EnrolmentStatus,
    R.FinishTime,
    R.Position
FROM Event E
JOIN [User] Org ON E.OrganiserID = Org.UserID
JOIN Category C ON E.EventID = C.EventID
JOIN Enrolment En ON E.EventID = En.EventID AND C.CategoryID = En.CategoryID
JOIN [User] P ON En.ParticipantID = P.UserID
LEFT JOIN Result R ON En.EnrolmentID = R.EnrolmentID
ORDER BY E.Date, EventName, ParticipantName;

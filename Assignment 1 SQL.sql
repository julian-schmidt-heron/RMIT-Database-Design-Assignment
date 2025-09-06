-- Create PoliticalParty table
CREATE TABLE PoliticalParty (
    PartyCode NVARCHAR(10) PRIMARY KEY,
    PartyName NVARCHAR(100),
    PartyLogo NVARCHAR(255),
    PostalAddress NVARCHAR(255),
    PartySecretary NVARCHAR(100),
    ContactPersonName NVARCHAR(100),
    ContactPersonPhone NVARCHAR(20),
    ContactPersonMobile NVARCHAR(20),
    ContactPersonEmail NVARCHAR(100)
);

-- Create Candidate table after PoliticalParty
CREATE TABLE Candidate (
    CandidateID INT PRIMARY KEY,
    Name NVARCHAR(100),
    ContactAddress NVARCHAR(255),
    ContactPhone NVARCHAR(20),
    ContactMobile NVARCHAR(20),
    ContactEmail NVARCHAR(100),
    PartyCode NVARCHAR(10),
    FOREIGN KEY (PartyCode) REFERENCES PoliticalParty(PartyCode)
);

-- Create ElectionMaster table
CREATE TABLE ElectionMaster (
    ElectionSerialNo INT PRIMARY KEY,
    ElectionDate DATE,
    Type NVARCHAR(50),
    TotalNumDivisions INT,
    TotalRegVoters INT,
    LastDateToVoterRegister DATE,
    LastDateCandidateNominate DATE,
    LastDateToDeclareResult DATE
);

-- Create ElectoralDivision table
CREATE TABLE ElectoralDivision (
    DivisionName NVARCHAR(100) PRIMARY KEY,
    TotalRegVoters INT,
    CurrMember NVARCHAR(100)
);

-- Create ElectionEvent table
CREATE TABLE ElectionEvent (
    ElectionEventID INT PRIMARY KEY,
    TotalVoters INT,
    VotesCast INT,
    VotesReject INT,
    VotesValid INT,
    ElectionSerialNo INT,
    DivisionName NVARCHAR(100),
    TwoCandidatePrefWinnerCandidateID INT,
    WinnerTally INT,
    TwoCandidatePrefLoserCandidateID INT,
    LoserTally INT,
    FOREIGN KEY (ElectionSerialNo) REFERENCES ElectionMaster(ElectionSerialNo),
    FOREIGN KEY (DivisionName) REFERENCES ElectoralDivision(DivisionName),
    FOREIGN KEY (TwoCandidatePrefWinnerCandidateID) REFERENCES Candidate(CandidateID),
    FOREIGN KEY (TwoCandidatePrefLoserCandidateID) REFERENCES Candidate(CandidateID)
);

-- Create Ballot table
CREATE TABLE Ballot (
    BallotID INT PRIMARY KEY,
    ElectionEventID INT,
    FOREIGN KEY (ElectionEventID) REFERENCES ElectionEvent(ElectionEventID)
);

-- Create BallotPreferences table
CREATE TABLE BallotPreferences (
    BallotID INT,
    CandidateID INT,
    Preference INT,
    PRIMARY KEY (BallotID, CandidateID),
    FOREIGN KEY (BallotID) REFERENCES Ballot(BallotID),
    FOREIGN KEY (CandidateID) REFERENCES Candidate(CandidateID)
);

-- Create Contests table
CREATE TABLE Contests (
    ElectionEventID INT,
    CandidateID INT,
    PRIMARY KEY (ElectionEventID, CandidateID),
    FOREIGN KEY (ElectionEventID) REFERENCES ElectionEvent(ElectionEventID),
    FOREIGN KEY (CandidateID) REFERENCES Candidate(CandidateID)
);

-- Create VoterRegistry table
CREATE TABLE VoterRegistry (
    VoterID NVARCHAR(50) PRIMARY KEY,
    FirstName NVARCHAR(50),
    MiddleNames NVARCHAR(50),
    LastName NVARCHAR(50),
    Address NVARCHAR(255),
    DoB DATE,
    Gender CHAR(1),
    ResidentialAddress NVARCHAR(255),
    PostalAddress NVARCHAR(255),
    ContactPhone NVARCHAR(20),
    ContactMobile NVARCHAR(20),
    ContactEmail NVARCHAR(100),
    DivisionName NVARCHAR(100),
    FOREIGN KEY (DivisionName) REFERENCES ElectoralDivision(DivisionName)
);

-- Create IssuanceRecord table
CREATE TABLE IssuanceRecord (
    VoterID NVARCHAR(50),
    ElectionEventID INT,
    IssueDate DATE,
    Timestamp DATE,
    PollingStation NVARCHAR(100),
    PRIMARY KEY (VoterID, ElectionEventID),
    FOREIGN KEY (VoterID) REFERENCES VoterRegistry(VoterID),
    FOREIGN KEY (ElectionEventID) REFERENCES ElectionEvent(ElectionEventID)
);

-- Create PrefCountRecord table
CREATE TABLE PrefCountRecord (
    ElectionEventID INT,
    RoundNo INT,
    EliminatedCandidateID INT,
    CountStatus NVARCHAR(50),
    PreferenceAggregate INT,
    PRIMARY KEY (ElectionEventID, RoundNo),
    FOREIGN KEY (ElectionEventID) REFERENCES ElectionEvent(ElectionEventID),
    FOREIGN KEY (EliminatedCandidateID) REFERENCES Candidate(CandidateID)
);

-- Create PreferenceTallyPerRoundPerCandidate table
CREATE TABLE PreferenceTallyPerRoundPerCandidate (
    ElectionEventID INT,
    RoundNo INT,
    CandidateID INT,
    PreferenceTally INT,
    PRIMARY KEY (ElectionEventID, RoundNo, CandidateID),
    FOREIGN KEY (ElectionEventID) REFERENCES ElectionEvent(ElectionEventID),
    FOREIGN KEY (CandidateID) REFERENCES Candidate(CandidateID)
);

-- Create ElectoralDivisionHistory table
CREATE TABLE ElectoralDivisionHistory (
    DivisionName NVARCHAR(100),
    ElectionSerialNo INT,
    HistoricRegVoters INT,
    PRIMARY KEY (DivisionName, ElectionSerialNo),
    FOREIGN KEY (DivisionName) REFERENCES ElectoralDivision(DivisionName),
    FOREIGN KEY (ElectionSerialNo) REFERENCES ElectionMaster(ElectionSerialNo)
);


-- Drop existing tables in reverse order of dependencies if nessesary
DROP TABLE IF EXISTS PreferenceTallyPerRoundPerCandidate;
DROP TABLE IF EXISTS PrefCountRecord;
DROP TABLE IF EXISTS IssuanceRecord;
DROP TABLE IF EXISTS BallotPreferences;
DROP TABLE IF EXISTS Contests;
DROP TABLE IF EXISTS Ballot;
DROP TABLE IF EXISTS VoterRegistry;
DROP TABLE IF EXISTS ElectionEvent;
DROP TABLE IF EXISTS ElectoralDivisionHistory;
DROP TABLE IF EXISTS ElectoralDivision;
DROP TABLE IF EXISTS Candidate;
DROP TABLE IF EXISTS PoliticalParty;
DROP TABLE IF EXISTS ElectionMaster;


-- Insert sample data into ElectionMaster table
INSERT INTO ElectionMaster (ElectionSerialNo, ElectionDate, Type, TotalNumDivisions, TotalRegVoters, LastDateToVoterRegister, LastDateCandidateNominate, LastDateToDeclareResult)
VALUES
    (20220521, '2022-05-21', 'Federal', 151, 16000000, '2022-04-01', '2022-04-09', '2022-05-31');

    -- Insert data for the 2019 election
INSERT INTO ElectionMaster (ElectionSerialNo, ElectionDate, Type, TotalNumDivisions, TotalRegVoters, LastDateToVoterRegister, LastDateCandidateNominate, LastDateToDeclareResult)
VALUES
    (20190518, '2019-05-18', 'Federal', 151, 15000000, '2019-04-01', '2019-04-09', '2019-05-31');


    --view the updated table
Select * from ElectionMaster;
--end

--populate PoliticalParty table with sample variables
--set PartyLogo to null as takes up exxes memory and not needed for the assignment tasks
INSERT INTO PoliticalParty (PartyCode, PartyName, PartyLogo, PostalAddress, PartySecretary, ContactPersonName, ContactPersonPhone, ContactPersonMobile, ContactPersonEmail)
VALUES 
('LIB', 'Liberal Party of Australia', NULL, 'Cnr Blackall and Macquarie St, Barton ACT 2600', 'John Smith', 'Emily Brown', '02 6277 2000', '0412 345 678', 'contact@liberal.org.au'),
('ALP', 'Australian Labor Party', NULL, '5/9 Sydney Avenue, Barton ACT 2600', 'Jane Doe', 'Mark Wilson', '02 6277 4000', '0413 678 234', 'contact@alp.org.au'),
('GRN', 'The Greens', NULL, '2/38 Sydney Avenue, Forrest ACT 2603', 'Michael Green', 'Sarah Thompson', '02 6140 3220', '0405 123 456', 'contact@greens.org.au'),
('UAP', 'United Australia Party', NULL, '240 Queen Street, Brisbane QLD 4000', 'Clive Palmer', 'Anna White', '07 3839 3844', '0409 876 543', 'contact@unitedaustraliaparty.org.au'),
('PHON', 'Pauline Hanson One Nation', NULL, 'PO Box 574, Inala QLD 4077', 'Pauline Hanson', 'Jake Roberts', '07 3372 4544', '0403 765 432', 'contact@onenation.org.au');

--view the updated table
Select * from PoliticalParty

--end

--populate Candidate table with sample variables
-- Insert sample data into Candidate table with correct PartyCode references
INSERT INTO Candidate (CandidateID, Name, ContactAddress, ContactPhone, ContactMobile, ContactEmail, PartyCode)
VALUES
    (13321, 'Anthony Albanese', '123 Parliament St, Sydney', '0298765432', '0412345678', 'anthony.albanese@alp.org', 'ALP'),
    (17846, 'Peter Dutton', '456 Government Rd, Brisbane', '0731234567', '0477891234', 'peter.dutton@liberal.org.au', 'LIB'),
    (17258, 'Adam Bandt', '789 Green Ave, Melbourne', '0387654321', '0456789123', 'adam.bandt@greens.org.au', 'GRN'),
    (20645, 'Pauline Hanson', '12 Hanson Dr, Ipswich', '0734567890', '0409876543', 'pauline.hanson@onenation.org.au', 'PHON'),
    (10268, 'Clive Palmer', '321 Palmer Pl, Gold Coast', '0754321987', '0498765432', 'clive.palmer@unitedaustraliaparty.org.au', 'UAP'),
    (20553, 'Craig Kelly', '123 Freedom St, Sydney', '0298761234', '0412123456', 'craig.kelly@unitedaustraliaparty.org.au', 'UAP');

--view the updated table
select * from Candidate
--end


-- Commands to populate DivisionName column in ElectoralDivision table after uploading just DivisionName column variables from csv to ElectoralDivision1 table 

select * from ElectoralDivision1

-- Insert DivisionName values into ElectoralDivision from ElectoralDivision1
INSERT INTO ElectoralDivision (DivisionName)
SELECT column1
FROM ElectoralDivision1;

--view updated table
select * from ElectoralDivision

--end

-- populate ElectionEvent with select values required for the assignment after uploading from csv to ElectionEvent1 table
select * from ElectionEvent1

INSERT INTO ElectionEvent (
    ElectionEventID, TotalVoters, ElectionSerialNo, DivisionName
)
SELECT
    ElectionEventID, TotalVoters, ElectionSerialNo, DivisionName
FROM
    ElectionEvent1;

select * from ElectionEvent;

--end

-- Insert sample data into Contests table based on prefiously created fake 6 candidates based on ids provided in the assignment description
INSERT INTO Contests (ElectionEventID, CandidateID)
VALUES
    (1, 13321),  -- Anthony Albanese
    (6, 17846),  -- Peter Dutton
    (20, 17258),  -- Adam Bandt
    (51, 20645),  -- Pauline Hanson
    (32, 10268),  -- Clive Palmer
    (143, 20553);  -- Craig Kelly

-- Verify data inserted into Contests table
SELECT * FROM Contests;


--end

-- populate VoterRegistry after uploading from csv to VoterRegistry1 table

select * from VoterRegistry1


INSERT INTO VoterRegistry (VoterID, FirstName, MiddleNames, LastName, Address, DoB, Gender, ResidentialAddress, PostalAddress, ContactPhone, ContactMobile, ContactEmail, DivisionName)
SELECT 
    VoterID, 
    FirstName,
    MiddleNames,
    LastName,
    Address,
    CAST(DoB AS DATE),  
    Gender,
    ResidentialAddress,
    PostalAddress,
    ContactPhone,
    ContactMobile,
    ContactEmail,
    DivisionName
FROM VoterRegistry1;

--view updated table
select * from VoterRegistry

--end

-- Commands to populate IssuanceRecord after uploading from csv to IssuanceRecord1 table
select * from IssuanceRecord1

--Insert Data from IssuanceRecord1 into IssuanceRecord
INSERT INTO IssuanceRecord (VoterID, ElectionEventID, IssueDate, Timestamp, PollingStation)
SELECT VoterID, ElectionEventID, IssueDate, Timestamp, PollingStation 
FROM IssuanceRecord1;



--view updated table

select * from IssuanceRecord


--end

-- Commands to populate Ballot table after uploading from csv to Ballot1 table
Select * from Ballot1

INSERT INTO Ballot (BallotID, ElectionEventID)
SELECT BallotID, ElectionEventID
FROM Ballot1;

Select * from Ballot

--end

-- Commands to populate BallotPreferences after uploading from csv to BallotPreferences1 table
select * from BallotPreferences1;

CREATE TABLE BallotPreferences_Staging (
    BallotID INT,
    CandidateID INT,
    Preference INT
);

INSERT INTO BallotPreferences_Staging (BallotID, CandidateID, Preference)
SELECT 
    CAST(CAST(BallotID AS VARCHAR) AS INT),
    CAST(CAST(CandidateID AS VARCHAR) AS INT),
    CAST(CAST(Preference AS VARCHAR) AS INT)
FROM BallotPreferences1
WHERE ISNUMERIC(CAST(BallotID AS VARCHAR)) = 1 
  AND ISNUMERIC(CAST(CandidateID AS VARCHAR)) = 1
  AND ISNUMERIC(CAST(Preference AS VARCHAR)) = 1;

select * from BallotPreferences_Staging

INSERT INTO BallotPreferences (BallotID, CandidateID, Preference)
SELECT BallotID, CandidateID, Preference
FROM BallotPreferences_Staging;

select * from BallotPreferences


-- end




--Task 2 code

--1. 
--Display electoral division name and total number of voters in descending order of the total number of voters
SELECT 
    vr.DivisionName, 
    COUNT(vr.VoterID) AS TotalVoters
FROM 
    VoterRegistry vr
GROUP BY 
    vr.DivisionName
ORDER BY 
    TotalVoters DESC;

--Create Index on VoterRegistry(DivisionName)
CREATE INDEX idx_VoterRegistry_DivisionName ON VoterRegistry (DivisionName);


--now run query again with index implemented in order to see if index helps

--follow-up statement to update the TotalRegVoters column in the ElectoralDivision table with the results of the above query.
UPDATE ElectoralDivision
SET TotalRegVoters = (
    SELECT COUNT(VoterID)
    FROM VoterRegistry vr
    WHERE vr.DivisionName = ElectoralDivision.DivisionName
)

--now view the updated table
select * from ElectoralDivision


--2
--Randomized Candidate List per Electoral Division

SELECT 
    ed.DivisionName, 
    c.Name AS CandidateName, 
    pp.PartyName 
FROM 
    Contests ct
JOIN 
    ElectionEvent ee ON ct.ElectionEventID = ee.ElectionEventID
JOIN 
    Candidate c ON ct.CandidateID = c.CandidateID
JOIN 
    ElectoralDivision ed ON ee.DivisionName = ed.DivisionName
JOIN 
    PoliticalParty pp ON c.PartyCode = pp.PartyCode
WHERE 
    ee.ElectionSerialNo = 20220521
ORDER BY 
    ed.DivisionName, NEWID();  -- NEWID() randomizes the candidates within each division

--create Index on Contests(ElectionEventID)
CREATE INDEX idx_Contests_ElectionEventID ON Contests (ElectionEventID);
--create Index on Candidate(PartyCode)
CREATE INDEX idx_Candidate_PartyCode ON Candidate (PartyCode);



--now run query again with index implemented in order to see if index helps:


SELECT 
    ed.DivisionName, 
    c.Name AS CandidateName, 
    pp.PartyName 
FROM 
    Contests ct WITH (INDEX(idx_Contests_ElectionEventID))  -- Force use of idx_Contests_ElectionEventID
JOIN 
    ElectionEvent ee ON ct.ElectionEventID = ee.ElectionEventID
JOIN 
    Candidate c WITH (INDEX(idx_Candidate_PartyCode))  -- Force use of idx_Candidate_PartyCode
    ON ct.CandidateID = c.CandidateID
JOIN 
    ElectoralDivision ed ON ee.DivisionName = ed.DivisionName
JOIN 
    PoliticalParty pp ON c.PartyCode = pp.PartyCode
WHERE 
    ee.ElectionSerialNo = 20220521
ORDER BY 
    ed.DivisionName, NEWID();  -- NEWID() randomizes the candidates within each division



--end

--3
--generate a report that lists the names and addresses of registered voters who did not vote in 2022 general election 
--(election event id: 20220521) and also not voted in 2019 general election (election event id: 20190518).
SELECT 
    vr.FirstName, 
    vr.LastName, 
    vr.Address 
FROM 
    VoterRegistry vr 
WHERE 
    vr.VoterID NOT IN (
        SELECT ir.VoterID
        FROM IssuanceRecord ir
        JOIN ElectionEvent ee ON ir.ElectionEventID = ee.ElectionEventID
        WHERE ee.ElectionSerialNo IN (20220521, 20190518)
    );



--create index on IssuanceRecord table
CREATE INDEX idx_IssuanceRecord_VoterID_ElectionEventID 
ON IssuanceRecord (VoterID, ElectionEventID);

--create index on ElectionEvent table
CREATE INDEX idx_ElectionEvent_ElectionSerialNo 
ON ElectionEvent (ElectionSerialNo);


--now run query again with index implemented in order to see if index helps:

SELECT 
    vr.FirstName, 
    vr.LastName, 
    vr.Address 
FROM 
    VoterRegistry vr 
WHERE 
    vr.VoterID NOT IN (
        SELECT ir.VoterID
        FROM IssuanceRecord ir WITH (INDEX(idx_IssuanceRecord_VoterID_ElectionEventID))
        JOIN ElectionEvent ee WITH (INDEX(idx_ElectionEvent_ElectionSerialNo)) ON ir.ElectionEventID = ee.ElectionEventID
        WHERE ee.ElectionSerialNo IN (20220521, 20190518)
    );


--Task 3 code

--table 1, VoterRegistry

-- Create Partition Function
CREATE PARTITION FUNCTION pf_VoterRegistry (NVARCHAR(100))
AS RANGE LEFT FOR VALUES (
    'Adelaide', 'Aston', 'Ballarat', 'Banks', 'Barker', 'Barton', 'Bass', 'Bean', 'Bendigo', 'Bennelong', 'Berowra', 'Blair', 'Blaxland', 
    'Bonner', 'Boothby', 'Bowman', 'Braddon', 'Bradfield', 'Brand', 'Brisbane', 'Bruce', 'Burt', 'Calare', 'Calwell', 'Canberra', 
    'Canning', 'Capricornia', 'Casey', 'Chifley', 'Chisholm', 'Clark', 'Cook', 'Cooper', 'Corangamite', 'Corio', 'Cowan', 'Cowper', 
    'Cunningham', 'Curtin', 'Dawson', 'Deakin', 'Dickson', 'Dobell', 'Dunkley', 'Durack', 'Eden-Monaro', 'Fadden', 'Fairfax', 'Farrer', 
    'Fenner', 'Fisher', 'Flinders', 'Flynn', 'Forde', 'Forrest', 'Fowler', 'Franklin', 'Fraser', 'Fremantle', 'Gellibrand', 'Gilmore', 
    'Gippsland', 'Goldstein', 'Gorton', 'Grayndler', 'Greenway', 'Grey', 'Griffith', 'Groom', 'Hasluck', 'Hawke', 'Herbert', 'Higgins', 
    'Hindmarsh', 'Hinkler', 'Holt', 'Hotham', 'Hughes', 'Hume', 'Hunter', 'Indi', 'Isaacs', 'Jagajaga', 'Kennedy', 'Kingsford Smith', 
    'Kingston', 'Kooyong', 'La Trobe', 'Lalor', 'Leichhardt', 'Lilley', 'Lindsay', 'Lingiari', 'Longman', 'Lyne', 'Lyons', 'Macarthur', 
    'Mackellar', 'Macnamara', 'Macquarie', 'Makin', 'Mallee', 'Maranoa', 'Maribyrnong', 'Mayo', 'McEwen', 'McMahon', 'McPherson', 
    'Melbourne', 'Menzies', 'Mitchell', 'Monash', 'Moncrieff', 'Moore', 'Moreton', 'New England', 'Newcastle', 'Nicholls', 'North Sydney', 
    'O''Connor', 'Oxley', 'Page', 'Parkes', 'Parramatta', 'Paterson', 'Pearce', 'Perth', 'Petrie', 'Rankin', 'Reid', 'Richmond', 'Riverina', 
    'Robertson', 'Ryan', 'Scullin', 'Shortland', 'Solomon', 'Spence', 'Sturt', 'Swan', 'Sydney', 'Tangney', 'Wannon', 'Warringah', 
    'Watson', 'Wentworth', 'Werriwa', 'Whitlam', 'Wide Bay', 'Wills', 'Wright'
);

-- Create Partition Scheme
CREATE PARTITION SCHEME ps_VoterRegistry
AS PARTITION pf_VoterRegistry
ALL TO ([PRIMARY]);

-- Create the Partitioned Table with Partitioned Primary Key
CREATE TABLE DivisionNamePartitionedVoterRegistry (
    VoterID NVARCHAR(50),
    FirstName NVARCHAR(50),
    MiddleNames NVARCHAR(50),
    LastName NVARCHAR(50),
    Address NVARCHAR(255),
    DoB DATE,
    Gender CHAR(1),
    ResidentialAddress NVARCHAR(255),
    PostalAddress NVARCHAR(255),
    ContactPhone NVARCHAR(20),
    ContactMobile NVARCHAR(20),
    ContactEmail NVARCHAR(100),
    DivisionName NVARCHAR(100),
    PRIMARY KEY (VoterID, DivisionName),  -- Including DivisionName in the primary key
    FOREIGN KEY (DivisionName) REFERENCES ElectoralDivision(DivisionName)
)
ON ps_VoterRegistry(DivisionName);

--now populate the new partitioned table with the data
INSERT INTO DivisionNamePartitionedVoterRegistry
SELECT * FROM VoterRegistry;

--view the new partitioned table
SELECT  * FROM DivisionNamePartitionedVoterRegistry

--table 2, ElectionEvent

-- Create Partition Function
CREATE PARTITION FUNCTION pf_ElectionEvent (INT)
AS RANGE LEFT FOR VALUES (20190518, 20220521);  -- Key elections for 2019 and 2022

-- Create Partition Scheme
CREATE PARTITION SCHEME ps_ElectionEvent
AS PARTITION pf_ElectionEvent
ALL TO ([PRIMARY]);

-- Create the Partitioned Table with Partitioned Primary Key
CREATE TABLE ElectionSerialNoPartitionedElectionEvent (
    ElectionEventID INT,
    TotalVoters INT,
    VotesCast INT,
    VotesReject INT,
    VotesValid INT,
    ElectionSerialNo INT,
    DivisionName NVARCHAR(100),
    TwoCandidatePrefWinnerCandidateID INT,
    WinnerTally INT,
    TwoCandidatePrefLoserCandidateID INT,
    LoserTally INT,
    PRIMARY KEY (ElectionSerialNo, ElectionEventID),  -- Including ElectionSerialNo in the primary key
    FOREIGN KEY (ElectionSerialNo) REFERENCES ElectionMaster(ElectionSerialNo),
    FOREIGN KEY (DivisionName) REFERENCES ElectoralDivision(DivisionName),
    FOREIGN KEY (TwoCandidatePrefWinnerCandidateID) REFERENCES Candidate(CandidateID),
    FOREIGN KEY (TwoCandidatePrefLoserCandidateID) REFERENCES Candidate(CandidateID)
)
ON ps_ElectionEvent(ElectionSerialNo);


--now populate the new partitioned table with the data
INSERT INTO ElectionSerialNoPartitionedElectionEvent
SELECT * FROM ElectionEvent;

--view the new partitioned table
SELECT  * FROM ElectionSerialNoPartitionedElectionEvent

--table 3, IssuanceRecord

-- Create Partition Function
CREATE PARTITION FUNCTION pf_IssuanceRecord (INT)
AS RANGE LEFT FOR VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151);  -- Patrition on the unique ElectionEventID range (1 to 151)

-- Create Partition Scheme
CREATE PARTITION SCHEME ps_IssuanceRecord
AS PARTITION pf_IssuanceRecord
ALL TO ('PRIMARY') ;

-- Create Partitioned Table
CREATE TABLE ElectionEventIDPartitionedIssuanceRecord (
    VoterID NVARCHAR(50),
    ElectionEventID INT,
    IssueDate DATE,
    Timestamp DATE,
    PollingStation NVARCHAR(100),
    PRIMARY KEY (VoterID, ElectionEventID),
    FOREIGN KEY (VoterID) REFERENCES VoterRegistry(VoterID),
    FOREIGN KEY (ElectionEventID) REFERENCES ElectionEvent(ElectionEventID)
)
ON ps_IssuanceRecord(ElectionEventID);

--now populate the new partitioned table with the data
INSERT INTO ElectionEventIDPartitionedIssuanceRecord
SELECT * FROM IssuanceRecord;

--view the new partitioned table
SELECT  * FROM ElectionEventIDPartitionedIssuanceRecord


--Task 4 code

--create the stored function
CREATE FUNCTION previouslyVoted (
    @ElectionSerialNo INT,
    @DivisionName NVARCHAR(100),
    @VoterID NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @HasVoted BIT;
    
    -- First, ensure the voter belongs to the specified division in VoterRegistry
    IF EXISTS (
        SELECT 1
        FROM VoterRegistry VR
        WHERE VR.VoterID = @VoterID
        AND VR.DivisionName = @DivisionName
    )
    BEGIN
        -- If the voter belongs to the division, check if they have a record in IssuanceRecord for the given election serial number
        IF EXISTS (
            SELECT 1
            FROM IssuanceRecord IR
            INNER JOIN ElectionEvent EE ON IR.ElectionEventID = EE.ElectionEventID
            WHERE EE.ElectionSerialNo = @ElectionSerialNo
            AND IR.VoterID = @VoterID
        )
        BEGIN
            SET @HasVoted = 1;  -- Voter has already voted
        END
        ELSE
        BEGIN
            SET @HasVoted = 0;  -- Voter has not voted yet
        END
    END
    ELSE
    BEGIN
        -- Voter doesn't belong to the input division
        SET @HasVoted = 0;
    END

    RETURN @HasVoted;
END;


--test function to see if voter with id 6 has voted in the 2022 election
SELECT dbo.previouslyVoted(20220521, 'Adelaide', '133') AS HasVoted;
--returns 1, meaning they have. I double checked this, and it is correct

--test function to see if voter with id 1000 has voted in the 2022 election
SELECT dbo.previouslyVoted(20220521, 'Werriwa', '1000') AS HasVoted;
--returns 0, meaning they have. I double checked this, and it is correct




--Task 5 code
-- Create the stored procedure
CREATE PROCEDURE primaryVoteCount
    @ElectionSerialNo INT,
    @DivisionName NVARCHAR(100)
AS
BEGIN
    -- Ensure we're working with the correct election event
    DECLARE @ElectionEventID INT;
    SET @ElectionEventID = (SELECT ElectionEventID
                            FROM ElectionEvent
                            WHERE ElectionSerialNo = @ElectionSerialNo
                            AND DivisionName = @DivisionName);

    -- Ensure the election event exists
    IF @ElectionEventID IS NULL
    BEGIN
        PRINT 'No matching election event found.';
        RETURN;
    END

    -- Clear previous tally records for this election event and round 1
    DELETE FROM PreferenceTallyPerRoundPerCandidate
    WHERE ElectionEventID = @ElectionEventID AND RoundNo = 1;

    -- Insert the first preference counts into PreferenceTallyPerRoundPerCandidate
    INSERT INTO PreferenceTallyPerRoundPerCandidate (ElectionEventID, RoundNo, CandidateID, PreferenceTally)
    SELECT
        @ElectionEventID AS ElectionEventID,
        1 AS RoundNo,
        BP.CandidateID,
        COUNT(*) AS PreferenceTally
    FROM BallotPreferences BP
    INNER JOIN Ballot B ON BP.BallotID = B.BallotID
    INNER JOIN ElectionEvent EE ON B.ElectionEventID = EE.ElectionEventID
    WHERE EE.ElectionSerialNo = @ElectionSerialNo
    AND EE.DivisionName = @DivisionName
    AND BP.Preference = 1
    GROUP BY BP.CandidateID;

    -- insert/update records in PrefCountRecord and aggregate counts in a way suitable for PrefCountRecord
    -- Clear previous counts for this round
    DELETE FROM PrefCountRecord
    WHERE ElectionEventID = @ElectionEventID AND RoundNo = 1;

    -- Insert or update the aggregate counts
    INSERT INTO PrefCountRecord (ElectionEventID, RoundNo, EliminatedCandidateID, CountStatus, PreferenceAggregate)
    SELECT
        @ElectionEventID AS ElectionEventID,
        1 AS RoundNo,
        NULL AS EliminatedCandidateID,
        'Active' AS CountStatus,
        SUM(PreferenceTally) AS PreferenceAggregate
    FROM PreferenceTallyPerRoundPerCandidate
    WHERE ElectionEventID = @ElectionEventID
    AND RoundNo = 1
    GROUP BY ElectionEventID;

    PRINT 'Primary vote counts updated successfully.';
END;


-- Execute the stored procedure again for a another election serial number and division name
EXEC primaryVoteCount @ElectionSerialNo = 20220521, @DivisionName = 'Macarthur';


-- View updated preference tallies in table PreferenceTallyPerRoundPerCandidate
SELECT *
FROM PreferenceTallyPerRoundPerCandidate
WHERE ElectionEventID = (SELECT ElectionEventID
                         FROM ElectionEvent
                         WHERE ElectionSerialNo = 20220521
                         AND DivisionName = 'Macarthur')
AND RoundNo = 1;


-- View updated preference count records in table PrefCountRecord
SELECT *
FROM PrefCountRecord
WHERE ElectionEventID = (SELECT ElectionEventID
                         FROM ElectionEvent
                         WHERE ElectionSerialNo = 20220521
                         AND DivisionName = 'Macarthur')
AND RoundNo = 1;


-- Clear PreferenceTallyPerRoundPerCandidate table for testing
DELETE FROM PreferenceTallyPerRoundPerCandidate;

-- Clear PrefCountRecord table for testing
DELETE FROM PrefCountRecord;

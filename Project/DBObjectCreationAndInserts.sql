-- Create sequences
DROP SEQUENCE TRADES_SEQUENCE;
DROP SEQUENCE DBLOGS_SEQUENCE;
DROP SEQUENCE EXCEEDAMNT_SEQUENCE;

Create sequence trades_sequence start with 1
increment by 1
minvalue 1
maxvalue 100000;

Create sequence dblogs_sequence start with 1
increment by 1
minvalue 1
maxvalue 9999999999;

CREATE SEQUENCE exceedamnt_sequence start with 1
increment by 1
minvalue 1
maxvalue 9999999999;

-- Table Creation
DROP TABLE Currencies CASCADE CONSTRAINTS;
DROP TABLE InstrumentType CASCADE CONSTRAINTS;
DROP TABLE Instruments CASCADE CONSTRAINTS;
DROP TABLE Countries CASCADE CONSTRAINTS;
DROP TABLE Counterparties CASCADE CONSTRAINTS;
DROP TABLE AccountsTypes CASCADE CONSTRAINTS;
DROP TABLE OurAccountsBalances CASCADE CONSTRAINTS;
DROP TABLE OurAccounts CASCADE CONSTRAINTS;
DROP TABLE CounterpartiesAccounts CASCADE CONSTRAINTS;
DROP TABLE UsersRoles CASCADE CONSTRAINTS;
DROP TABLE OurSystemUsers CASCADE CONSTRAINTS;
DROP TABLE Trades CASCADE CONSTRAINTS;
DROP TABLE DBOperationsLogs CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------------------------------------------
CREATE TABLE Currencies (
                  Currency varchar(3), 
                  CurrencyLongName varchar(25) NOT NULL, 
                  CONSTRAINT Currency_pk PRIMARY KEY(Currency),
                  CONSTRAINT LongName_uk UNIQUE (CurrencyLongName));
                  
CREATE TABLE InstrumentType (
                  InstrumentTypeID number(2),
                  TypeDecription varchar(25) NOT NULL, 
                  CONSTRAINT InstrumentType_pk PRIMARY KEY(InstrumentTypeID),
                  CONSTRAINT TypeDecription_uk UNIQUE (TypeDecription));
                  
CREATE TABLE Instruments (
                  InstrumentID varchar(15), 
                  InstrumentTypeID number(2) NOT NULL, 
                  Currency varchar(3) NOT NULL, 
                  IssueDate date NOT NULL, 
                  MaturityDate date NOT NULL, 
                  IsCallable number(1) NOT NULL, 
                  CONSTRAINT InstrumentID_pk  PRIMARY KEY(InstrumentID),
                  CONSTRAINT IntType_fk FOREIGN KEY(InstrumentTypeID) REFERENCES InstrumentType(InstrumentTypeID));
                  
CREATE TABLE Countries (
                CountryISO varchar(3), 
                Country varchar(30) NOT NULL,
                CONSTRAINT iso_pk  PRIMARY KEY(CountryISO),              
                CONSTRAINT Country_uk UNIQUE (Country));        
                
CREATE TABLE Counterparties (
                CounterpartyID number(4), 
                BankName varchar(25) NOT NULL, 
                BranchNo number(3) NOT NULL, 
                SWIFTCode varchar(8) NOT NULL, 
                Address varchar(255) NOT NULL, 
                CountryISO varchar(3) NOT NULL, 
                Contact varchar(255) NOT NULL, 
                DateAdded date NOT NULL, 
                CONSTRAINT CounterpartyID_pk PRIMARY KEY(CounterpartyID),
                CONSTRAINT CountryISO_fk FOREIGN KEY(CountryISO) REFERENCES Countries(CountryISO));
                
CREATE TABLE AccountsTypes (
                AccountTypeID number(1), 
                AccountTypeDescription varchar(10) NOT NULL, 
                CONSTRAINT AccountTypeID_pk PRIMARY KEY(AccountTypeID));
                               
CREATE TABLE OurAccounts (
                OurAccountNo number(4), 
                AccountTypeID number(1) NOT NULL, 
                Currency varchar(3) NOT NULL, 
                DateOpened date NOT NULL, 
                Status varchar(8) NOT NULL, 
                CONSTRAINT OurAccountNo_pk PRIMARY KEY(OurAccountNo),
                CONSTRAINT Type_fk FOREIGN KEY(AccountTypeID) REFERENCES AccountsTypes(AccountTypeID));

CREATE TABLE OurAccountsBalances (
                BalanceID number(6), 
                OurAccountNo number(4) NOT NULL, 
                AsOfDate date NOT NULL, 
                Balance number(14,2) NOT NULL, 
                CONSTRAINT BalanceID_pk PRIMARY KEY(BalanceID),
                CONSTRAINT OurAccountNo_fk FOREIGN KEY(OurAccountNo) REFERENCES OurAccounts(OurAccountNo));
                
CREATE TABLE CounterpartiesAccounts (
                CounterpartyAccountNo number(4), 
                Counterparty number(4) NOT NULL, 
                AccountTypeID number(1) NOT NULL, 
                Currency varchar(3) NOT NULL, 
                DateOpened date NOT NULL, 
                Status varchar(8) NOT NULL, 
                CONSTRAINT CounterpartyAccountNo_pk PRIMARY KEY(CounterpartyAccountNo),
                CONSTRAINT AccountTypeID_fk FOREIGN KEY(AccountTypeID) REFERENCES AccountsTypes(AccountTypeID));  
                
CREATE TABLE UsersRoles (
                RoleID number(2), 
                RoleDesciption varchar(15) NOT NULL, 
                CONSTRAINT RoleID_pk PRIMARY KEY(RoleID),
                CONSTRAINT RoleDesciption_uk UNIQUE (RoleDesciption));
                
CREATE TABLE OurSystemUsers (
                UserID varchar(15), 
                RoleID number(2), 
                FullName varchar(15) NOT NULL, 
                CreatedDate DATE NOT NULL, 
                Status varchar(8) NOT NULL, 
                Email varchar(40) NOT NULL, 
                CONSTRAINT UserID_pk PRIMARY KEY(UserID),
                CONSTRAINT RoleID_fk FOREIGN KEY(RoleID) REFERENCES UsersRoles(RoleID),
                CONSTRAINT FullName_uk UNIQUE (FullName),
                CONSTRAINT Email_uk UNIQUE (Email));                
                
CREATE TABLE Trades (
                TradeID number(6), 
                InstrumentID varchar(15), 
                UserID varchar(15), 
                DealDate date NOT NULL, 
                SettlementDate date NOT NULL, 
                Amount number(11,2) NOT NULL, 
                Buy_Sell number(1) NOT NULL, 
                CounterpartyID number(4), 
                OurAccountNo number(4), 
                CounterpartyAccountNo number(4), 
                Narrative varchar(255), 
                CONSTRAINT TradeID_pk PRIMARY KEY(TradeID),
                CONSTRAINT Trade_InstrumentID_fk FOREIGN KEY(InstrumentID) REFERENCES Instruments(InstrumentID),
                CONSTRAINT Trade_UserID_fk FOREIGN KEY(UserID) REFERENCES OurSystemUsers(UserID),
                CONSTRAINT Trade_CounterpartyID_fk FOREIGN KEY(CounterpartyID) REFERENCES Counterparties(CounterpartyID),
                CONSTRAINT Trade_OurAccountNo_fk FOREIGN KEY(OurAccountNo) REFERENCES OurAccounts(OurAccountNo),
                CONSTRAINT Trade_CounterpartyAccountNo_fk FOREIGN KEY(CounterpartyAccountNo) REFERENCES CounterpartiesAccounts(CounterpartyAccountNo));             
                
CREATE TABLE ExceedAmnt_Log (
LogID NUMBER(7) PRIMARY KEY,
Amount FLOAT(10),
tradeID number(6),
CONSTRAINT Trade_tradeid_fk FOREIGN KEY(tradeID) REFERENCES Trades(tradeID)
);

commit;

-- Insertion of records
--1-----------------------------------------------------------------------------------
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('USD','United States dollar');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('EUR','European Euro');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('GBP','Great Britain Pound');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('JPY','Japanese Yen');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('AUD','Australian Dollar');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('CNY','Chinese Yuan Renminbi');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('CAD','Canadian Dollar');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('PHP','Philippine peso');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('RUB','Russian ruble');
INSERT INTO Currencies (Currency, CurrencyLongName) VALUES ('ALL','Albanian lek');
--2-----------------------------------------------------------------------------------
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (1, 'Deposits');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (2, 'Treasury bond');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (3, 'Treasury bill');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (4, 'Domestic treasury bond');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (5, 'Domestic treasury bill');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (6, 'Corporate bill');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (7, 'Corporate bond');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (8, 'Inflation linked bond');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (9, 'Municipal bond');
INSERT INTO InstrumentType (InstrumentTypeID, TypeDecription) VALUES (10, 'Mortgage-backed bond');
--3-----------------------------------------------------------------------------------
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('DE000HVB3XK8',1,'JPY',TO_DATE('2003-03-15', 'YYYY-MM-DD'),TO_DATE('2023-03-15', 'YYYY-MM-DD'),1);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('RU000A1012L2',5,'AUD',TO_DATE('2003-07-18', 'YYYY-MM-DD'),TO_DATE('2023-07-18', 'YYYY-MM-DD'),0);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS1972456468',7,'CNY',TO_DATE('2003-11-20', 'YYYY-MM-DD'),TO_DATE('2023-11-20', 'YYYY-MM-DD'),1);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('Deposit-1Y-ALL',1,'ALL',TO_DATE('2008-08-13', 'YYYY-MM-DD'),TO_DATE('2009-08-13', 'YYYY-MM-DD'),1);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2031082220',8,'USD',TO_DATE('2004-03-24', 'YYYY-MM-DD'),TO_DATE('2024-03-24', 'YYYY-MM-DD'),1);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2031601516',1,'EUR',TO_DATE('2004-07-27', 'YYYY-MM-DD'),TO_DATE('2024-07-27', 'YYYY-MM-DD'),0);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2062825174',6,'GBP',TO_DATE('2004-11-29', 'YYYY-MM-DD'),TO_DATE('2024-11-29', 'YYYY-MM-DD'),0);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2062565174',7,'USD',TO_DATE('2005-04-03', 'YYYY-MM-DD'),TO_DATE('2025-04-03', 'YYYY-MM-DD'),1);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2068051882',7,'EUR',TO_DATE('2005-08-06', 'YYYY-MM-DD'),TO_DATE('2025-08-06', 'YYYY-MM-DD'),0);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2069476831',3,'CAD',TO_DATE('2005-12-09', 'YYYY-MM-DD'),TO_DATE('2025-12-09', 'YYYY-MM-DD'),0);
INSERT INTO Instruments (InstrumentID,InstrumentTypeID,Currency,IssueDate,MaturityDate,IsCallable) VALUES ('XS2074551990',8,'ALL',TO_DATE('2006-04-13', 'YYYY-MM-DD'),TO_DATE('2026-04-13', 'YYYY-MM-DD'),0);
--4-----------------------------------------------------------------------------------
INSERT INTO Countries (CountryISO,Country) VALUES ('CAN','Canada');
INSERT INTO Countries (CountryISO,Country) VALUES ('USA','United States of America');
INSERT INTO Countries (CountryISO,Country) VALUES ('TUR','Turkey');
INSERT INTO Countries (CountryISO,Country) VALUES ('GRC','Greece');
INSERT INTO Countries (CountryISO,Country) VALUES ('JPN','Japan');
INSERT INTO Countries (CountryISO,Country) VALUES ('AUS','Australia');
INSERT INTO Countries (CountryISO,Country) VALUES ('ALB','Albania');
INSERT INTO Countries (CountryISO,Country) VALUES ('BGR','Bulgaria');
INSERT INTO Countries (CountryISO,Country) VALUES ('ITA','Italy');
INSERT INTO Countries (CountryISO,Country) VALUES ('PHL','Philippines');
--5-----------------------------------------------------------------------------------
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (1,'JPMorgan Chase',2,'CHASGB2L','123 Berry Road','PHL','John Smith',TO_DATE('2003-03-15', 'YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (2,'Bank of America',13,'BOFAUS3N','456 Progress Ave','USA','Adan Moore',TO_DATE('2003-11-05','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (3,'TD Bank',12,'NRTHUS33','975 Warden Ave','CAN','Liz Marly',TO_DATE('2004-06-27','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (4,'HSBC Holdings',87,'MRMDUS3','876 Christie Ave','TUR','Era Bego',TO_DATE('2005-02-17','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (5,'State Street',5,'SBOSUS33','532 Bathurst Street','AUS','Ilia Merko',TO_DATE('2005-10-10','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (6,'Royal Bank of Canada',4,'ROYCCAT2','432 Islington Road','CAN','Brian McDonald',TO_DATE('2006-06-02','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (7,'Mizuho International',12,'NOSKNOK','543 Royal Road','JPN','Zerina Kuke',TO_DATE('2007-01-23','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (8,'Bank of Montreal',13,'DUS3MRM','951 Kennedy Ave','BGR','Besi Qahajaj',TO_DATE('2007-09-15','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (9,'Raiffeisen Bank',5,'YCCCCAT2','432 Marklam Street','ALB','Erinda Doci',TO_DATE('2008-05-07','YYYY-MM-DD'));
INSERT INTO Counterparties (CounterpartyID,BankName,BranchNo,SWIFTCode,Address,CountryISO,Contact,DateAdded) VALUES (10,'Alpha Bank',7,'SGB2LCHA','893 Kipling Street','GRC','Arjan Elmazi',TO_DATE('2008-12-28','YYYY-MM-DD'));
--6-----------------------------------------------------------------------------------	
INSERT INTO AccountsTypes (AccountTypeID,AccountTypeDescription) VALUES (1,'Security');
INSERT INTO AccountsTypes (AccountTypeID,AccountTypeDescription) VALUES (2,'Cash');
--7-----------------------------------------------------------------------------------
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (1,1,'ALL',TO_DATE('2000-03-15','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (2,2,'ALL',TO_DATE('2000-03-15','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (3,1,'USD',TO_DATE('2001-04-16','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (4,2,'USD',TO_DATE('2002-05-18','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (5,1,'EUR',TO_DATE('2002-05-18','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (6,2,'EUR',TO_DATE('2002-05-18','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (7,1,'CAD',TO_DATE('2003-05-28','YYYY-MM-DD'),'Inactive');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (8,2,'CAD',TO_DATE('2003-05-28','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (9,2,'GBP',TO_DATE('2002-07-04','YYYY-MM-DD'),'Active');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (10,1,'JPY',TO_DATE('2002-12-24','YYYY-MM-DD'),'Closed');
INSERT INTO OurAccounts (OurAccountNo,AccountTypeID,Currency,DateOpened,Status) VALUES (11,2,'JPY',TO_DATE('2002-12-24','YYYY-MM-DD'),'Active');
--8-----------------------------------------------------------------------------------
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (1,1,TO_DATE('2003-05-28','YYYY-MM-DD'),123456.47);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (2,2,TO_DATE('2003-05-28','YYYY-MM-DD'),36587.36);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (3,3,TO_DATE('2003-05-28','YYYY-MM-DD'),789345.65);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (4,4,TO_DATE('2003-05-28','YYYY-MM-DD'),7892472.36);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (5,5,TO_DATE('2003-05-28','YYYY-MM-DD'),587546.35);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (6,6,TO_DATE('2003-05-28','YYYY-MM-DD'),117579092.70);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (7,7,TO_DATE('2003-05-28','YYYY-MM-DD'),3157382.60);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (8,8,TO_DATE('2003-05-28','YYYY-MM-DD'),16797013.24);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (9,9,TO_DATE('2003-05-28','YYYY-MM-DD'),87705.07);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (10,10,TO_DATE('2003-05-28','YYYY-MM-DD'),864195.29);
INSERT INTO OurAccountsBalances (BalanceID,OurAccountNo,AsOfDate,Balance) VALUES (11,11,TO_DATE('2003-05-28','YYYY-MM-DD'),23515185.40);
--9-----------------------------------------------------------------------------------
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (1,'Dealer');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (2,'Manager');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (3,'MiddleOffice');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (4,'BackOffice');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (5,'Risk');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (6,'Accounting');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (7,'Controller');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (8,'Audit');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (9,'Payments');
INSERT INTO UsersRoles (RoleID,RoleDesciption) VALUES (10,'Oversight');
--10-----------------------------------------------------------------------------------
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('imeko',1,'Iris Meko',TO_DATE('2003-04-28','YYYY-MM-DD'),'Active','imeko@my.centennialcollege.ca');  
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('bsantas',1,'Bruno Santas',TO_DATE('2003-04-29','YYYY-MM-DD'),'Active','bsanta@my.centennialcollege.ca');      
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('apeev',2,'Antoni Peev',TO_DATE('2003-04-29','YYYY-MM-DD'),'Active','apeev@my.centennialcollege.ca');      
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('kpo',2,'Katrina Po',TO_DATE('2003-04-30','YYYY-MM-DD'),'Active','kpo@my.centennialcollege.ca');      
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('vdineshan',3,'Varun Dineshan',TO_DATE('2003-04-30','YYYY-MM-DD'),'Closed','vdiesh@my.centennialcollege.ca'); 
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('emiandej',4,'Elham Miandej',TO_DATE('2003-05-01','YYYY-MM-DD'),'Inactive','emiaej@my.centennialcollege.ca');  
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('dsoni',5,'Dimple Soni',TO_DATE('2003-05-01','YYYY-MM-DD'),'Inactive','dsoni@my.centennialcollege.ca');      
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('hnahid',6,'Hossain Nahid',TO_DATE('2003-05-02','YYYY-MM-DD'),'Inactive','hnahid@my.centennialcollege.ca');      
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('jchen',9,'Jacky Chen',TO_DATE('2003-05-02','YYYY-MM-DD'),'Closed','jchen@my.centennialcollege.ca');      
INSERT INTO OurSystemUsers (UserID,RoleID,FullName,CreatedDate,Status,Email) VALUES ('ccalina',10,'Curtis Calina',TO_DATE('2003-05-03','YYYY-MM-DD'),'Inactive','ccalin@my.centennialcollege.ca');    
--11-----------------------------------------------------------------------------------
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (1,10,1,'ALL',TO_DATE('2008-12-28','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (2,10,2,'ALL',TO_DATE('2008-12-28','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (3,3,1,'USD',TO_DATE('2004-06-27','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (4,3,1,'CAD',TO_DATE('2004-06-27','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (5,7,1,'JPY',TO_DATE('2007-01-23','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (6,7,1,'EUR',TO_DATE('2007-01-23','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (7,6,1,'CAD',TO_DATE('2006-06-02','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (8,6,2,'USD',TO_DATE('2006-06-02','YYYY-MM-DD'),'Active');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (9,9,1,'ALL',TO_DATE('2008-05-07','YYYY-MM-DD'),'Inactive');
INSERT INTO CounterpartiesAccounts (CounterpartyAccountNo,Counterparty,AccountTypeID,Currency,DateOpened,Status) VALUES (10,9,2,'ALL',TO_DATE('2008-05-07','YYYY-MM-DD'),'Inactive');       
--12-----------------------------------------------------------------------------------
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2068051882','imeko',TO_DATE('2007-08-06','YYYY-MM-DD'),TO_DATE('2007-08-08','YYYY-MM-DD'),25000000,1,7,6,6,'This deal of buying 25 mio of security XS2068051882 from Mizuho is done for investment portfolio.'); 
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'DE000HVB3XK8','bsantas',TO_DATE('2008-03-18','YYYY-MM-DD'),TO_DATE('2008-03-20','YYYY-MM-DD'),13520000,2,7,11,5,'This deal of selling 13.52 mio of security DE000HVB3XK8 to Mizuho is done for liquidity portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2062565174','apeev',TO_DATE('2006-08-27','YYYY-MM-DD'),TO_DATE('2006-08-29','YYYY-MM-DD'),10000000,1,3,4,3,'This deal of buying 10 mio of security XS2062565174 from TD is done for working capital portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2069476831','kpo',TO_DATE('2007-12-13','YYYY-MM-DD'),TO_DATE('2007-12-15','YYYY-MM-DD'),8500000,2,3,8,4,'This deal of selling 8.5 mio of security XS2069476831 to TD is done for liquidity portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2074551990','bsantas',TO_DATE('2009-01-15','YYYY-MM-DD'),TO_DATE('2009-01-17','YYYY-MM-DD'),105000000,1,10,2,2,'This deal of buying 105 mio of security XS2074551990 from Alpha is done for working capital portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2074551990','kpo',TO_DATE('2009-06-17','YYYY-MM-DD'),TO_DATE('2009-06-19','YYYY-MM-DD'),75000000,2,10,2,2,'This deal of selling 75 mio of security XS2074551990 to Alpha is done for investment portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2069476831','imeko',TO_DATE('2010-03-18','YYYY-MM-DD'),TO_DATE('2010-03-20','YYYY-MM-DD'),40000000,1,6,8,7,'This deal of buying 40 mio of security XS2069476831 from RBC is done for liquidity portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2062565174','apeev',TO_DATE('2011-04-25','YYYY-MM-DD'),TO_DATE('2011-04-27','YYYY-MM-DD'),30000000,2,6,4,8,'This deal of selling 30 mio of security XS2062565174 to RBC is done for investment portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'XS2074551990','apeev',TO_DATE('2012-11-06','YYYY-MM-DD'),TO_DATE('2012-11-08','YYYY-MM-DD'),120000000,2,9,2,10,'This deal of selling 120 mio of security XS2074551990 to Raiffeisen is done for liabilities portfolio.');
INSERT INTO Trades(TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (trades_sequence.nextval,'Deposit-1Y-ALL','bsantas',TO_DATE('2008-08-11','YYYY-MM-DD'),TO_DATE('2008-08-13','YYYY-MM-DD'),95000000,1,9,1,9,'This deal of placing 95 mio deposit to Raiffeisen is done for liquidity portfolio.');

commit;

-- PROCEDURES:
-- Procedure that takes tradeid and ouraccountno as parameters and updates the balance in ouraccountsbalances table

CREATE OR REPLACE PROCEDURE update_accountbalance_sp
(p_accountno IN trades.ouraccountno%TYPE,
p_tradeid IN trades.tradeid%TYPE)
IS
p_buysell trades.buy_sell%TYPE;
p_amount trades.amount%TYPE;
p_trade_id trades.tradeid%TYPE;
p_balance ouraccountsbalances.balance%TYPE;
BEGIN
SELECT t.amount, t.buy_sell, t.tradeid, b.balance
into p_amount, p_buysell, p_trade_id,p_balance
from trades t, ouraccountsbalances b
where t.ouraccountno = b.ouraccountno
and tradeid = p_tradeid;
IF p_buysell = 1 THEN
p_balance := p_balance - p_amount;
ELSE
p_balance := p_balance + p_amount;
UPDATE ouraccountsbalances
set balance = p_balance
where ouraccountno = p_accountno;
END IF;
END update_accountbalance_sp;

-- Procedure that takes a userid and dealdate as a parameter and returns the associated tradeid

CREATE OR REPLACE PROCEDURE get_trade_sp
(p_userid IN trades.userid%TYPE,
p_dealdate IN trades.dealdate%TYPE)
AS
p_counttransactions NUMBER;
p_tradeid trades.tradeid%TYPE;
BEGIN
SELECT tradeid
into p_tradeid
from
trades
where userid = p_userid
and dealdate = p_dealdate;
DBMS_OUTPUT.PUT_LINE('Trade id: '|| p_tradeid);
END get_trade_sp;

-- FUNCTIONS
-- Function that takes dates as parameters and returns the total amount of security sold between those dates

CREATE OR REPLACE FUNCTION total_sales_sf
(p_fromdate IN trades.dealdate%TYPE,
p_todate IN trades.dealdate%TYPE)
return NUMBER
is 
lv_total NUMBER(12,2);
lv_amount NUMBER(12,2);
BEGIN 
SELECT sum(amount)
into lv_amount
from trades
where dealdate between p_fromdate and p_todate
and buy_sell = 2;
lv_total := lv_amount;
return lv_total;
END total_sales_sf;

-- Function that takes dates as parameters and returns the total amount bought between those dates
CREATE OR REPLACE FUNCTION total_bought_sf
(p_fromdate IN trades.dealdate%TYPE,
p_todate IN trades.dealdate%TYPE)
return NUMBER
is 
lv_total_bought NUMBER(12,2);
lv_amount_bought NUMBER(12,2);
BEGIN 
SELECT sum(amount)
into lv_amount_bought
from trades
where dealdate between p_fromdate and p_todate
and buy_sell = 1;
lv_total_bought := lv_amount_bought;
return lv_total_bought;
END total_bought_sf;

-- TRIGGERS:
--trigger to generate a log in the exceedamnt_log table if a transaction with the amount 499.000.000 is entered in the db/high risk transaction

CREATE OR REPLACE TRIGGER Trig_ExceedAmnt
AFTER
 INSERT ON Trades
 FOR EACH ROW
 DECLARE
 Amnt EXCEEDAMNT_LOG.Amount%TYPE;
BEGIN
Amnt := :NEW.Amount;
IF (Amnt > 499000000) THEN
INSERT INTO EXCEEDAMNT_LOG (LogID, Amount)
VALUES(exceedamnt_sequence.NEXTVAL, Amnt);
DBMS_OUTPUT.PUT_LINE('Amount (' || Amnt || ') exceeds max limit of 499.000.000, please contact the transaction department for more information');
END IF;
END TRIG_EXCEEDAMNT;


--Trigger that shows a message when a balance is updated successfully in one of our accounts
CREATE OR REPLACE TRIGGER succesful_balance_trg
AFTER UPDATE ON ouraccountsbalances
FOR EACH ROW
BEGIN
DBMS_OUTPUT.PUT_LINE('Balance update successful');
END succesful_balance_trg;

--INDEXES
--1
CREATE INDEX trades_index ON 
trades(TradeID,InstrumentID,UserID,CounterPartyID,OurAccountNO,CounterpartyAccountNo);
--2
CREATE INDEX counterpartiesacc_index ON
counterpartiesaccounts(CounterpartyAccountNo,AccountTypeID,Currency);
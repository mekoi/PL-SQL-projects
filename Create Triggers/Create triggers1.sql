/*Assignment 9-9*/
--------------------------------------------------------------------------------------
/*Dropping sequence*/
DROP SEQUENCE DD_PTRACK_SEQ; 
--------------------------------------------------------------------------------------
/*Creating sequence*/
Create sequence DD_PTRACK_SEQ start with 1
increment by 1
minvalue 1
maxvalue 999000;
--------------------------------------------------------------------------------------
/*Dropping table*/
DROP TABLE DD_PAYTRACK;
--------------------------------------------------------------------------------------
/*Creating table for saving logs-pledge payment activity*/
CREATE TABLE DD_PAYTRACK(
    IdLog number(6),
    UserName varchar(25) NOT NULL,
    CurrentDate date NOT NULL, 
    Action varchar(6) NOT NULL, 
    IdPay number(6) NOT NULL,
    CONSTRAINT IdLog_pk PRIMARY KEY(IdLog));
--------------------------------------------------------------------------------------
/*Creating trigger*/
CREATE OR REPLACE TRIGGER trackpayment_trg
AFTER INSERT or UPDATE or DELETE ON dd_payment  
FOR EACH ROW
DECLARE   
BEGIN  
if inserting then
insert into DD_PAYTRACK (IdLog,UserName,CurrentDate,Action,IdPay) values (DD_PTRACK_SEQ.nextval,user,TO_DATE(sysdate,'YY-MM-DD'),'INSERT',:new.idpay); 
end if;
if updating then   
insert into DD_PAYTRACK (IdLog,UserName,CurrentDate,Action,IdPay) values (DD_PTRACK_SEQ.nextval,user,TO_DATE(sysdate,'YY-MM-DD'),'UPDATE',:new.idpay);      
end if;
if deleting then
insert into DD_PAYTRACK (IdLog,UserName,CurrentDate,Action,IdPay) values (DD_PTRACK_SEQ.nextval,user,TO_DATE(sysdate,'YY-MM-DD'),'DELETE',:old.idpay); 
end if;
END;  
--------------------------------------------------------------------------------------
/*Testing trigger*/
alter session set nls_date_format='YY-MM-DD';

select * from dd_payment order by idpay;
select * from DD_PAYTRACK;

insert into dd_payment (idpay, idpledge, payamt, paydate, paymethod) values (3000,110,25,TO_DATE('19-07-27','YY-MM-DD'),'AA');
update dd_payment set paymethod='YY' where idpay=3000;
delete from dd_payment where idpay=3000;

commit;


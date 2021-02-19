/*Assignment 9-10*/
--------------------------------------------------------------------------------------
/*Creating trigger*/
CREATE OR REPLACE TRIGGER check_first_plegde_trg
FOR INSERT ON dd_pledge 
COMPOUND TRIGGER
number_of_pledges number(4);
idPledge_inserted number(5);
BEFORE EACH ROW IS
BEGIN
idPledge_inserted:=:new.IDPLEDGE;
select count(*) into number_of_pledges from dd_pledge where iddonor=:new.idDonor;
END BEFORE EACH ROW;
AFTER STATEMENT IS
BEGIN
if number_of_pledges<1 then update DD_Pledge set Firstpledge='Y' where idpledge=idPledge_inserted;
else update DD_Pledge set Firstpledge='N' where idpledge=idPledge_inserted;
end if;
END AFTER STATEMENT;
END;
--------------------------------------------------------------------------------------
/*Testing trigger*/
alter session set nls_date_format='YY-MM-DD';
select * from dd_pledge order by 2,1;

INSERT INTO dd_pledge VALUES (114,309,TO_DATE('13-03-01','YY-MM-DD'),75,500,20,NULL,0,738,'Y');  ---The insert is done with Firstpledge=Y, in order to test whether the trigger updates it into N. 
INSERT INTO dd_pledge VALUES (115,305,TO_DATE('13-03-01','YY-MM-DD'),75,500,20,NULL,0,738,'N');  ---The insert is done with Firstpledge=N, in order to test whether the trigger updates it into Y.
INSERT INTO dd_pledge VALUES (116,304,TO_DATE('13-03-01','YY-MM-DD'),75,500,20,NULL,0,738,Null);  ---The insert is done with Firstpledge=Null, in order to test whether the trigger updates it into N. 
commit;
select * from dd_pledge order by 2,1;

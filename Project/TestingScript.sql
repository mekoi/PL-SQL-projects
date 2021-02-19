

-- Test update_accountbalance_sp
DECLARE
lv_accountno trades.ouraccountno%TYPE;
lv_tradeid trades.tradeid%TYPE;
BEGIN
SELECT ouraccountno,tradeid
into lv_accountno,lv_tradeid
from trades
where tradeid=6;
update_accountbalance_sp(lv_accountno,lv_tradeid);
END;

-- Test get_trade_sp
DECLARE
lv_userid trades.userid%TYPE;
lv_dealdate trades.dealdate%TYPE;
BEGIN
lv_dealdate := TO_DATE('2011-04-25','YYYY-MM-DD');
SELECT userid
into lv_userid
from trades
where userid = 'apeev'
and dealdate = lv_dealdate;
get_trade_sp(lv_userid,lv_dealdate);
END;

-- Test total_sales_sf
DECLARE
lv_fromdate trades.dealdate%TYPE;
lv_todate trades.dealdate%TYPE;
lv_salestotal NUMBER(12,2);
BEGIN
lv_salestotal := total_sales_sf(TO_DATE('2008-03-15','YYYY-MM-DD'),TO_DATE('2011-04-25','YYYY-MM-DD'));
DBMS_OUTPUT.PUT_LINE('Amount of security sold during this time range is : ' || lv_salestotal);
END;


-- Test total_bought_sf
DECLARE
lv_fromdate trades.dealdate%TYPE;
lv_todate trades.dealdate%TYPE;
lv_salestotal NUMBER(12,2);
BEGIN
lv_salestotal := total_bought_sf(TO_DATE('2008-03-15','YYYY-MM-DD'),TO_DATE('2011-04-25','YYYY-MM-DD'));
DBMS_OUTPUT.PUT_LINE('Amount of security bought during this time range is : ' || lv_salestotal);
END;

--test ExceedAmnt_Seq
INSERT INTO Trades (TradeID,InstrumentID,UserID,DealDate,SettlementDate,Amount,Buy_Sell,CounterpartyID,OurAccountNo,CounterpartyAccountNo,Narrative)
VALUES (12,'XS2074551990','apeev',SYSDATE,SYSDATE,500000000,2,6,8,10,'null');
DELETE FROM Trades WHERE TradeID = 12;
select * from ExceedAmnt_Log;

--test succesful_balance_trg
update ouraccountsbalances
set balance = 123456.47
where balanceid = 1;


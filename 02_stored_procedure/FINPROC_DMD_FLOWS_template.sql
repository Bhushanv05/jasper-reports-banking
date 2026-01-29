---------------------------------------------
--------------------------------------------------------------------------------------------------
CREATE OR REPLACE package custom.FINPACK_DMD_FLOWS
AS
PROCEDURE FINPROC_DMD_FLOWS(inp_str IN VARCHAR2, out_retCode OUT NUMBER, out_rec OUT VARCHAR2);
END FINPACK_DMD_FLOWS;
/
show Errors package custom.FINPACK_DMD_FLOWS;
--------------------------------------------------------------------------------------------------
-------------------------------Package Body-------------------------------------------------------
--------------------------------------------------------------------------------------------------
CREATE OR REPLACE package body custom.FINPACK_DMD_FLOWS
AS
--------------------------------------------------------------------------------------------------
------------------------------ Declaration of Variables-------------------------------------------
--------------------------------------------------------------------------------------------------
outArr                          TBAADM.basp0099.ArrayType;
--i_sol_id                        VARCHAR2(100 CHAR);
i_rownum                        VARCHAR2(100 CHAR);
i_cust_id                       VARCHAR2(100 CHAR);
i_account                       VARCHAR2(100 CHAR);
i_acct_name                     VARCHAR2(100 CHAR);
i_asset_code                    VARCHAR2(100 CHAR);
i_asset_desc                    VARCHAR2(100 CHAR);
i_tran_amt                      VARCHAR2(100 CHAR);
i_charges                       VARCHAR2(100 CHAR);
i_interest                      VARCHAR2(100 CHAR);
i_pricipal                      VARCHAR2(100 CHAR);
i_offlowamt                     VARCHAR2(100 CHAR);
i_adj_date                      VARCHAR2(100 CHAR);


r_customerid                    VARCHAR2(100 CHAR);
r_tran_date                     DATE;

-------------------------------------------------------------------------------------------------
-----------------------------------------Cursor--------------------------------------------------
--------------------------------------------------------------------------------------------------
Cursor C_DMD_FLOW is

WITH htd_agg AS (
    SELECT acid,TRUNC(tran_date) AS tran_date,SUM(tran_amt) AS tran_amt
    FROM tbaadm.htd
    WHERE del_flg = 'N' AND part_tran_type = 'C' AND TRUNC(tran_date) = r_tran_date 
    GROUP BY acid, TRUNC(tran_date)
),
ldt_agg AS (
    SELECT acid,TRUNC(last_adj_date) AS adj_date,
        SUM(CASE WHEN dmd_flow_id IN ('BCDEM','OCDEM')THEN tot_adj_amt ELSE 0 END) AS charges,
        SUM(CASE WHEN dmd_flow_id IN ('INDEM','PIDEM')THEN tot_adj_amt ELSE 0 END) AS indem,
        SUM(CASE WHEN dmd_flow_id = 'PRDEM'THEN tot_adj_amt ELSE 0 END) AS prdem
    FROM tbaadm.ldt
    WHERE TRUNC(last_adj_date) = r_tran_date 
    GROUP BY acid, TRUNC(last_adj_date)
)
SELECT
    rownum,
    b.cif_id,
    b.foracid,
    b.acct_name,
    c.asset_code,
    d.asset_desc,
    NVL(h.tran_amt, 0) AS tran_amt,
    CASE WHEN NVL(h.tran_amt,0) >= NVL(l.charges,0)THEN NVL(l.charges,0)ELSE NVL(h.tran_amt,0)END AS charges,--charges
    CASE WHEN NVL(h.tran_amt,0) > NVL(l.charges,0)THEN LEAST(NVL(l.indem,0),NVL(h.tran_amt,0) - NVL(l.charges,0))ELSE 0 END AS indem,--INDEM
    CASE WHEN NVL(h.tran_amt,0) > (NVL(l.charges,0) + NVL(l.indem,0))THEN LEAST(NVL(l.prdem,0),NVL(h.tran_amt,0) - NVL(l.charges,0) - NVL(l.indem,0))ELSE 0 END AS prdem,--PRDEM
    CASE WHEN NVL(h.tran_amt,0) >(NVL(l.charges,0) + NVL(l.indem,0) + NVL(l.prdem,0))
        THEN NVL(h.tran_amt,0) -(NVL(l.charges,0) + NVL(l.indem,0) + NVL(l.prdem,0)) ELSE 0 END AS offlow_amt,--OFFLOW
    nvl(TO_CHAR(l.adj_date, 'DD-MM-YYYY'),'NULL') AS adj_date
FROM tbaadm.gam b
LEFT JOIN htd_agg h ON b.acid = h.acid
LEFT JOIN ldt_agg l ON b.acid = l.acid
LEFT JOIN tbaadm.lam c ON c.acid = b.acid
LEFT JOIN custom.c_sacct d ON c.asset_code = d.asset_code

WHERE b.acct_cls_flg != 'Y'
  AND b.schm_type IN ('LAA','ODA')
  AND b.cif_id = r_customerid
  AND NVL(h.tran_amt,0) <> 0;
--------------------------------------------------------------------------------------------------
---------------------------------------Procedure--------------------------------------------------
--------------------------------------------------------------------------------------------------
PROCEDURE FINPROC_DMD_FLOWS(inp_str In Varchar2,out_retCode OUT Number,out_rec OUT varchar2)
AS
OutArr        TBAADM.basp0099.ArrayType;
BEGIN
        out_retCode:=0;
        IF ( NOT C_DMD_FLOW%ISOPEN ) THEN
        --{
               TBAADM.basp0099.formInputArr(inp_str,OutArr);
               r_customerid   :=outArr(0);
               r_tran_date    :=to_date(outArr(1),'DD-MM-YYYY');
                OPEN C_DMD_FLOW ;

        --}
        END IF;

        IF (C_DMD_FLOW%ISOPEN) THEN
                Fetch C_DMD_FLOW into

                i_rownum,
                i_cust_id,
                i_account,
                i_acct_name,
                i_asset_code,
                i_asset_desc,
                i_tran_amt,
                i_charges,
                i_interest,
                i_pricipal,
                i_offlowamt,
                i_adj_date;
        end if;

        if(C_DMD_FLOW%FOUND) then

                out_rec:=(
                i_rownum        ||'|'||
                i_cust_id       ||'|'||
                i_account       ||'|'||
                i_acct_name     ||'|'||
                i_asset_code    ||'|'||
                i_asset_desc    ||'|'||
                i_tran_amt      ||'|'||
                i_charges       ||'|'||
                i_interest      ||'|'||
                i_pricipal      ||'|'||
                i_offlowamt     ||'|'||
                i_adj_date);

        else
                out_retCode := 1;
                close C_DMD_FLOW;
                return;
        end if;

END  FINPROC_DMD_FLOWS;
END FINPACK_DMD_FLOWS;
/
show Errors package body custom.FINPACK_DMD_FLOWS;
/
CREATE OR REPLACE SYNONYM TBAADM.FINPACK_DMD_FLOWS FOR FINPACK_DMD_FLOWS
/
CREATE OR REPLACE SYNONYM TBAGEN.FINPACK_DMD_FLOWS FOR FINPACK_DMD_FLOWS
/
CREATE OR REPLACE SYNONYM TBAUTIL.FINPACK_DMD_FLOWS FOR FINPACK_DMD_FLOWS
/
GRANT  execute  on custom.FINPACK_DMD_FLOWS  to  TBAADM,tbagen,tbautil,custom
/
show err

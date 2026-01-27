-- =====================================================
-- FINACLE STORED PROCEDURE FOR JASPER REPORTS
-- =====================================================
-- Package: FINPACK_DMD_FLOWS
-- Procedure: FINPROC_DMD_FLOWS
-- Purpose: Loan Recovery Details Report
-- Author: Bhushan R Chougule
-- Database: Oracle 11g/12c/19c
-- Note: This is a TEMPLATE with sample structure
-- =====================================================

-- =====================================================
-- PACKAGE SPECIFICATION
-- =====================================================
CREATE OR REPLACE PACKAGE CUSTOM.FINPACK_DMD_FLOWS AS
  
  -- Stored procedure for Loan Recovery Details Report
  PROCEDURE FINPROC_DMD_FLOWS(
    P_INP_STR      IN  VARCHAR2,      -- Input parameters concatenated
    P_OUT_RETCODE  OUT NUMBER,        -- Return code (0=success, 1=error)
    P_OUT_REC      OUT VARCHAR2       -- Output record set
  );

END FINPACK_DMD_FLOWS;
/

-- =====================================================
-- PACKAGE BODY
-- =====================================================
CREATE OR REPLACE PACKAGE BODY CUSTOM.FINPACK_DMD_FLOWS AS

  -- =====================================================
  -- PROCEDURE: FINPROC_DMD_FLOWS
  -- =====================================================
  PROCEDURE FINPROC_DMD_FLOWS(
    P_INP_STR      IN  VARCHAR2,
    P_OUT_RETCODE  OUT NUMBER,
    P_OUT_REC      OUT VARCHAR2
  ) IS
    
    -- Local variables
    v_cust_id       NUMBER;
    v_tran_date     DATE;
    v_delimiter     VARCHAR2(1) := '!';
    v_output_rec    VARCHAR2(32767);
    v_row_count     NUMBER := 0;
    
    -- Cursor to fetch loan recovery details
    CURSOR c_loan_recovery IS
      SELECT 
        ROWNUM as row_num,
        lr.cust_id,
        la.loan_account_no as account_no,
        cm.customer_name as name,
        la.asset_code,
        la.asset_desc,
        lr.transaction_amount as tran_amt,
        lr.charges,
        lr.interest_amount as interest,
        lr.principal_amount as principle,
        lr.outflow_amount as offlow_amt,
        lr.adjustment_date as adj_date
      FROM 
        loan_recovery_transactions lr
        INNER JOIN loan_accounts la ON lr.loan_account_no = la.loan_account_no
        INNER JOIN customer_master cm ON lr.cust_id = cm.cust_id
      WHERE 
        lr.cust_id = v_cust_id
        AND TRUNC(lr.transaction_date) = TRUNC(v_tran_date)
        AND lr.transaction_status = 'POSTED'
      ORDER BY 
        lr.transaction_date DESC, 
        lr.transaction_id DESC;
    
  BEGIN
    
    -- =====================================================
    -- STEP 1: Parse Input Parameters
    -- =====================================================
    -- Input format: "CUST_ID!TRAN_DATE"
    -- Example: "123456!31-DEC-2025"
    
    BEGIN
      -- Extract Customer ID
      v_cust_id := TO_NUMBER(
        SUBSTR(P_INP_STR, 1, INSTR(P_INP_STR, v_delimiter) - 1)
      );
      
      -- Extract Transaction Date
      v_tran_date := TO_DATE(
        SUBSTR(P_INP_STR, INSTR(P_INP_STR, v_delimiter) + 1),
        'DD-MON-YYYY'
      );
      
    EXCEPTION
      WHEN OTHERS THEN
        P_OUT_RETCODE := 1;
        P_OUT_REC := 'ERROR: Invalid input parameters - ' || SQLERRM;
        RETURN;
    END;
    
    -- =====================================================
    -- STEP 2: Validate Input Parameters
    -- =====================================================
    IF v_cust_id IS NULL OR v_tran_date IS NULL THEN
      P_OUT_RETCODE := 1;
      P_OUT_REC := 'ERROR: Customer ID and Transaction Date are required';
      RETURN;
    END IF;
    
    -- =====================================================
    -- STEP 3: Build Output Record Set
    -- =====================================================
    -- Output format: Field delimiter is pipe (|)
    -- Record delimiter is tilde (~)
    -- Format: field1|field2|field3|...~field1|field2|field3|...~
    
    v_output_rec := '';
    
    FOR rec IN c_loan_recovery LOOP
      
      v_row_count := v_row_count + 1;
      
      -- Build record string with all fields
      v_output_rec := v_output_rec ||
        rec.row_num || '|' ||                        -- Field 0: Rownum
        rec.cust_id || '|' ||                        -- Field 1: Cust_id
        rec.account_no || '|' ||                     -- Field 2: Account_No
        rec.name || '|' ||                           -- Field 3: Name
        rec.asset_code || '|' ||                     -- Field 4: Asset_code
        rec.asset_desc || '|' ||                     -- Field 5: Asset_desc
        TO_CHAR(rec.tran_amt, '999999990.99') || '|' ||    -- Field 6: Tran_amt
        TO_CHAR(rec.charges, '999999990.99') || '|' ||     -- Field 7: Charges
        TO_CHAR(rec.interest, '999999990.99') || '|' ||    -- Field 8: Interest
        TO_CHAR(rec.principle, '999999990.99') || '|' ||   -- Field 9: Principle
        TO_CHAR(rec.offlow_amt, '999999990.99') || '|' ||  -- Field 10: Offlow_amt
        TO_CHAR(rec.adj_date, 'DD-MON-YYYY') ||      -- Field 11: Adj_date
        '~';  -- Record delimiter
      
      -- Check if output exceeds maximum size
      IF LENGTH(v_output_rec) > 30000 THEN
        -- Log warning or handle pagination
        NULL;
      END IF;
      
    END LOOP;
    
    -- =====================================================
    -- STEP 4: Handle No Data Found
    -- =====================================================
    IF v_row_count = 0 THEN
      P_OUT_RETCODE := 0;
      P_OUT_REC := 'INFO: No loan recovery records found for Customer ID: ' || 
                   v_cust_id || ' on Date: ' || TO_CHAR(v_tran_date, 'DD-MON-YYYY');
      RETURN;
    END IF;
    
    -- =====================================================
    -- STEP 5: Return Success
    -- =====================================================
    P_OUT_RETCODE := 0;  -- Success
    P_OUT_REC := v_output_rec;
    
  EXCEPTION
    WHEN OTHERS THEN
      -- =====================================================
      -- ERROR HANDLING
      -- =====================================================
      P_OUT_RETCODE := 1;  -- Error
      P_OUT_REC := 'ERROR: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      
      -- Log error to error table (if exists)
      BEGIN
        INSERT INTO finacle_report_errors (
          error_date,
          report_name,
          error_code,
          error_message,
          input_parameters
        ) VALUES (
          SYSDATE,
          'LOAN_RECOVERY_DETAILS',
          SQLCODE,
          SQLERRM,
          P_INP_STR
        );
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL; -- Ignore logging errors
      END;
      
  END FINPROC_DMD_FLOWS;

END FINPACK_DMD_FLOWS;
/

-- =====================================================
-- GRANT PERMISSIONS
-- =====================================================
GRANT EXECUTE ON CUSTOM.FINPACK_DMD_FLOWS TO FINACLE_USER;
/

-- =====================================================
-- SAMPLE TABLE STRUCTURES (For Reference)
-- =====================================================

-- Customer Master Table
CREATE TABLE customer_master (
  cust_id           NUMBER(12) PRIMARY KEY,
  customer_name     VARCHAR2(100) NOT NULL,
  pan_number        VARCHAR2(10),
  mobile_number     VARCHAR2(15),
  email_address     VARCHAR2(100),
  customer_status   VARCHAR2(10) DEFAULT 'ACTIVE',
  created_date      DATE DEFAULT SYSDATE
);

-- Loan Accounts Table
CREATE TABLE loan_accounts (
  loan_account_no   VARCHAR2(20) PRIMARY KEY,
  cust_id           NUMBER(12) NOT NULL,
  asset_code        VARCHAR2(10),
  asset_desc        VARCHAR2(100),
  loan_amount       NUMBER(15,2),
  interest_rate     NUMBER(5,2),
  loan_status       VARCHAR2(10) DEFAULT 'ACTIVE',
  sanction_date     DATE,
  FOREIGN KEY (cust_id) REFERENCES customer_master(cust_id)
);

-- Loan Recovery Transactions Table
CREATE TABLE loan_recovery_transactions (
  transaction_id      NUMBER(15) PRIMARY KEY,
  loan_account_no     VARCHAR2(20) NOT NULL,
  cust_id             NUMBER(12) NOT NULL,
  transaction_date    DATE NOT NULL,
  transaction_amount  NUMBER(15,2) NOT NULL,
  principal_amount    NUMBER(15,2) DEFAULT 0,
  interest_amount     NUMBER(15,2) DEFAULT 0,
  charges             NUMBER(15,2) DEFAULT 0,
  outflow_amount      NUMBER(15,2) DEFAULT 0,
  adjustment_date     DATE,
  transaction_status  VARCHAR2(10) DEFAULT 'POSTED',
  created_by          VARCHAR2(50),
  created_date        DATE DEFAULT SYSDATE,
  FOREIGN KEY (loan_account_no) REFERENCES loan_accounts(loan_account_no)
);

-- Error Logging Table
CREATE TABLE finacle_report_errors (
  error_id          NUMBER(15) PRIMARY KEY,
  error_date        DATE DEFAULT SYSDATE,
  report_name       VARCHAR2(100),
  error_code        NUMBER,
  error_message     VARCHAR2(4000),
  input_parameters  VARCHAR2(1000)
);

-- Sequence for transaction ID
CREATE SEQUENCE seq_transaction_id START WITH 1 INCREMENT BY 1;

-- =====================================================
-- SAMPLE TEST DATA
-- =====================================================

-- Insert sample customer
INSERT INTO customer_master (cust_id, customer_name, pan_number, mobile_number)
VALUES (123456, 'John Doe', 'ABCDE1234F', '9876543210');

-- Insert sample loan account
INSERT INTO loan_accounts (loan_account_no, cust_id, asset_code, asset_desc, loan_amount, interest_rate, sanction_date)
VALUES ('LA0001234567', 123456, 'HL', 'Home Loan', 5000000, 8.5, SYSDATE - 365);

-- Insert sample recovery transaction
INSERT INTO loan_recovery_transactions (
  transaction_id, loan_account_no, cust_id, transaction_date,
  transaction_amount, principal_amount, interest_amount, charges, 
  outflow_amount, adjustment_date, transaction_status
)
VALUES (
  seq_transaction_id.NEXTVAL, 'LA0001234567', 123456, TRUNC(SYSDATE),
  50000, 40000, 9500, 500, 50000, TRUNC(SYSDATE), 'POSTED'
);

COMMIT;

-- =====================================================
-- TEST THE STORED PROCEDURE
-- =====================================================

DECLARE
  v_inp_str      VARCHAR2(100);
  v_out_retcode  NUMBER;
  v_out_rec      VARCHAR2(32767);
BEGIN
  
  -- Prepare input parameters
  v_inp_str := '123456!' || TO_CHAR(SYSDATE, 'DD-MON-YYYY');
  
  -- Call the procedure
  CUSTOM.FINPACK_DMD_FLOWS.FINPROC_DMD_FLOWS(
    P_INP_STR     => v_inp_str,
    P_OUT_RETCODE => v_out_retcode,
    P_OUT_REC     => v_out_rec
  );
  
  -- Display results
  DBMS_OUTPUT.PUT_LINE('Return Code: ' || v_out_retcode);
  DBMS_OUTPUT.PUT_LINE('Output: ' || v_out_rec);
  
END;
/

-- =====================================================
-- PERFORMANCE OPTIMIZATION
-- =====================================================

-- Create indexes for better performance
CREATE INDEX idx_loan_recovery_cust ON loan_recovery_transactions(cust_id, transaction_date);
CREATE INDEX idx_loan_recovery_acct ON loan_recovery_transactions(loan_account_no);
CREATE INDEX idx_loan_accounts_cust ON loan_accounts(cust_id);

-- Analyze tables for optimizer statistics
ANALYZE TABLE customer_master COMPUTE STATISTICS;
ANALYZE TABLE loan_accounts COMPUTE STATISTICS;
ANALYZE TABLE loan_recovery_transactions COMPUTE STATISTICS;

-- =====================================================
-- NOTES
-- =====================================================
/*
1. This is a TEMPLATE procedure - customize for your schema
2. Replace table/column names with actual Finacle tables
3. Adjust data types and sizes as per your requirements
4. Add proper error handling and logging
5. Test with actual data before deploying to production
6. Consider performance optimization for large datasets
7. Document all customizations for maintenance

8. Finacle SPBx Framework Requirements:
   - Input parameters must be concatenated with delimiter
   - Output must be in pipe-delimited format
   - Return code: 0 = success, 1 = error
   - Maximum output size considerations

9. Security Considerations:
   - Grant appropriate permissions only
   - Validate all input parameters
   - Prevent SQL injection
   - Log all errors for audit trail
*/

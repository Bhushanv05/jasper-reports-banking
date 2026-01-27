
# Finacle CBS - Jasper Reports Integration Tutorial

[![Finacle](https://img.shields.io/badge/Finacle_CBS-0052CC?style=for-the-badge&logo=databricks&logoColor=white)](https://www.edgeverve.com/finacle/)
[![Jasper Reports](https://img.shields.io/badge/Jasper_Reports-DC382D?style=for-the-badge&logo=jasmine&logoColor=white)](https://community.jaspersoft.com/)
[![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

## ?? Overview

A **complete end-to-end tutorial** for creating, deploying, and integrating Jasper Reports in Finacle Core Banking System. This repository contains a working example of a **Loan Recovery Details Report** with full documentation covering the entire workflow from design to deployment.

> **Based on 12+ years of production experience** implementing 300+ reports across 300+ branches serving 2.1M+ customer accounts.

---

## ?? What You'll Learn

### **Complete Finacle Report Workflow:**
1. ? **Design Phase** - Creating reports in iReport Designer using SPBx Proc framework
2. ? **Stored Procedure** - PL/SQL backend integration with Finacle
3. ? **Backend Deployment** - Unix/Linux deployment via Putty (chmod, deploy scripts)
4. ? **Frontend Integration** - Finacle menu configuration (FINRPTC, FINRPT)
5. ? **Access Management** - Role-based report access control
6. ? **Testing & Troubleshooting** - Verification and common issues

---

## ?? Example Report: Loan Recovery Details

### **Report Overview**
- **Purpose:** Display detailed loan recovery transactions for customers
- **Type:** Finacle SPBx Stored Procedure Report
- **Orientation:** Landscape (A4 - 1417x842 pixels)
- **Framework:** Custom SPBx Proc with Finacle integration
- **Bank:** The Satara DCC Bank, Satara

### **Report Features**
- ?? **12 Data Fields:** Customer details, loan account info, recovery breakdown
- ?? **Financial Breakdown:** Principal, Interest, Charges, Total amounts
- ?? **Date-based Filtering:** Transaction date parameter
- ?? **Customer-specific:** Filter by Customer ID
- ?? **Professional Layout:** Table format with borders and headers
- ?? **Bank Branding:** Header with bank name and report title

### **Input Parameters**
```
P_Cust_id      : Customer ID (Number)
P_Tran_date    : Transaction Date (Date)
```

### **Output Fields**
```
1. Rownum       - Serial number
2. Cust_id      - Customer identification
3. Account_No   - Loan account number
4. Name         - Customer name
5. Asset_code   - Asset/Product code
6. Asset_desc   - Asset description
7. Tran_amt     - Transaction amount
8. Charges      - Charges applied
9. Interest     - Interest amount
10. Principle   - Principal amount
11. Offlow_amt  - Outflow amount
12. Adj_date    - Adjustment date
```

---

## ?? Repository Structure

```
finacle-jasper-reports-tutorial/
+-- README.md                                    # This file
+-- LICENSE                                      # MIT License
¦
+-- 01_example_report/                           # Working Example
¦   +-- LOAN_RECOVERY_DETAILS2001.jrxml          # Complete report file
¦   +-- report_overview.md                       # Detailed explanation
¦   +-- sample_output.pdf                        # Expected output
¦
+-- 02_stored_procedure/                         # Backend Code
¦   +-- FINPACK_DMD_FLOWS.sql                    # Package specification
¦   +-- FINPROC_DMD_FLOWS.sql                    # Stored procedure
¦   +-- sample_tables.sql                        # Sample schema
¦   +-- test_data.sql                            # Dummy test data
¦
+-- 03_deployment/                               # Deployment Scripts
¦   +-- deploy_finrpt.sh                         # Deployment script
¦   +-- chmod_commands.txt                       # File permissions
¦   +-- directory_structure.txt                  # Server paths
¦   +-- deployment_guide.md                      # Step-by-step guide
¦
+-- 04_finacle_configuration/                    # Frontend Setup
¦   +-- finrptc_setup.md                         # Menu FINRPTC guide
¦   +-- role_assignment.md                       # Access control
¦   +-- testing_procedure.md                     # FINRPT testing
¦
+-- 05_design_tutorial/                          # iReport Designer
¦   +-- step_by_step_guide.md                    # Complete tutorial
¦   +-- ireport_setup.md                         # Tool installation
¦   +-- spbx_proc_framework.md                   # Framework explanation
¦   +-- design_best_practices.md                 # Tips and tricks
¦
+-- screenshots/                                 # Visual Documentation
¦   +-- 01_ireport_wizard.png
¦   +-- 02_spbx_selection.png
¦   +-- 03_stored_procedure_mapping.png
¦   +-- 04_field_configuration.png
¦   +-- 05_report_layout.png
¦   +-- 06_putty_deployment.png
¦   +-- 07_finrptc_configuration.png
¦   +-- 08_role_assignment.png
¦   +-- 09_final_report_output.png
¦
+-- templates/                                   # Reusable Templates
¦   +-- blank_finacle_report.jrxml               # Starting template
¦   +-- report_header_template.jrxml             # Standard header
¦   +-- stored_procedure_template.sql            # SP structure
¦
+-- docs/                                        # Additional Docs
    +-- finacle_report_configuration_guide.md    # Original PDF converted
    +-- prerequisites.md                         # Requirements
    +-- troubleshooting.md                       # Common issues
    +-- glossary.md                              # Technical terms
    +-- best_practices.md                        # Production tips
```

---

## ?? Quick Start Guide

### **Prerequisites**
- iReport Designer 5.6.0 or Jaspersoft Studio
- Oracle Database with Finacle schema access
- Putty or SSH client for server access
- Finacle CBS user credentials with report access
- Basic knowledge of PL/SQL and Jasper Reports

### **Step 1: Clone Repository**
```bash
git clone https://github.com/Bhushanv05/jasper-reports-banking.git
cd jasper-reports-banking
```

### **Step 2: Open Example Report**
1. Launch iReport Designer or Jaspersoft Studio
2. Open `01_example_report/LOAN_RECOVERY_DETAILS2001.jrxml`
3. Configure database connection
4. Preview the report

### **Step 3: Study the Workflow**
Follow the documentation in sequence:
1. Read `05_design_tutorial/step_by_step_guide.md`
2. Review `02_stored_procedure/` for backend code
3. Check `03_deployment/deployment_guide.md` for deployment
4. Configure frontend using `04_finacle_configuration/`

---

## ?? Complete Workflow Documentation

### **Phase 1: Report Design (iReport Designer)**

#### **1.1 Launch Report Wizard**
```
Plugin ? Report Wizard
```

#### **1.2 Select Framework**
```
Choose: Custom ? SPBx proc
```

#### **1.3 Database Connection**
```
Select: Target Database Connection
Choose: Template Layout
```

#### **1.4 Report Identification**
```
Settings Tab ? Enter Report Name: LOAN_RECOVERY_DETAILS2001
```

#### **1.5 Schema Mapping**
```
Data Fields ? ADD Fields
Query Wizard ? Select Database
Find Object ? Search: FINPACK_DMD_FLOWS.FINPROC_DMD_FLOWS
Next ? ADD Input Parameters (P_Cust_id, P_Tran_date)
Finish ? Generates .jrxml file
```

#### **1.6 Field Mapping**
```
Plugin ? Report Option ? Tables
Select All ? Map fields ? OK
```

#### **1.7 Cleanup**
```
Database Option ? Remove Custom
```

#### **1.8 Dynamic Fields**
```
Right-click Static Text ? Transform to TextField
```

---

### **Phase 2: Backend Deployment (Unix/Linux)**

#### **2.1 Server Access**
```bash
# Login to Finacle server via Putty
ssh username@finacle-server-ip
```

#### **2.2 Navigate to Report Directory**
```bash
# Directory structure
cd SCR
cd ../
cd JRXML
cd Jasper
cd Rpt
```

#### **2.3 Upload JRXML File**
```bash
# Upload your .jrxml file to the Rpt directory
# Using SCP, WinSCP, or FTP
```

#### **2.4 Set File Permissions**
```bash
# Give execution permissions
chmod 755 LOAN_RECOVERY_DETAILS2001.jrxml
```

#### **2.5 Deploy Report**
```bash
# Run deployment script
./deploy_finrpt.com LOAN_RECOVERY_DETAILS2001
```

---

### **Phase 3: Finacle Frontend Integration**

#### **3.1 Administrative Setup**
```
Navigate to: Menu FINRPTC
```

#### **3.2 Register Report**
```
Select: ADD
Enter Details:
  - Jasper Name: LOAN_RECOVERY_DETAILS2001 (exact filename)
  - Template Desc: Loan Recovery Details Report
  - Report Category: Loan Reports
Save
```

#### **3.3 Access Management**
```
ADD Role-id
Select: User roles who can access this report
Assign: Branch users, Managers, etc.
Save
```

#### **3.4 Verification**
```
Navigate to: Menu FINRPT
Search: LOAN_RECOVERY_DETAILS2001
Test: Enter parameters and generate report
```

---

## ?? Report Customization

### **Modify Bank Name**
```xml
<textFieldExpression class="java.lang.String">
  <![CDATA["The Satara DCC Bank, Satara"]]>
</textFieldExpression>
```
Change to your bank name in the Title band.

### **Adjust Page Size**
```xml
pageWidth="1417"    <!-- A4 Landscape width -->
pageHeight="842"    <!-- A4 Landscape height -->
```

### **Modify Colors & Fonts**
```xml
<font pdfFontName="Helvetica-Bold" size="14" isBold="true"/>
```

---

## ?? Stored Procedure Integration

### **SPBx Proc Framework**
The report uses Finacle's SPBx (Stored Procedure Box) framework:

```sql
{call FINPACK_DMD_FLOWS.FINPROC_DMD_FLOWS(
  $P{FIN_INP_STR},      -- Input parameters concatenated
  $P{FIN_OUT_RETCODE},  -- Return code (success/failure)
  $P{FIN_OUT_REC}       -- Output record set
)}
```

### **Parameter Handling**
```java
// Input parameters are concatenated
$P{FIN_INP_STR} = $P{P_Cust_id} + "!" + $P{P_Tran_date}
```

### **Field Mapping**
Fields are accessed by index from stored procedure output:
```xml
<field name="Cust_id" class="java.lang.String">
  <fieldDescription><![CDATA[1]]></fieldDescription>
</field>
```

---

## ?? Best Practices

### **Design Phase**
- ? Use descriptive report names (avoid spaces)
- ? Always test with sample data first
- ? Follow consistent naming conventions
- ? Add proper headers and footers
- ? Use page numbering for multi-page reports

### **Stored Procedure**
- ? Optimize SQL queries for performance
- ? Handle null values properly
- ? Add proper error handling
- ? Use indexed columns in WHERE clauses
- ? Test with large datasets

### **Deployment**
- ? Verify filename matches exactly (case-sensitive)
- ? Check file permissions (chmod 755)
- ? Test in development before production
- ? Keep backup of working reports
- ? Document all changes

### **Frontend Configuration**
- ? Use clear, descriptive Template Desc
- ? Assign appropriate role-based access
- ? Test with different user roles
- ? Verify parameter prompts work correctly
- ? Check output format (PDF/Excel/CSV)

---

## ?? Troubleshooting

### **Common Issues & Solutions**

#### **Issue: Report not showing in FINRPT menu**
```
Solution:
1. Verify filename in FINRPTC matches deployed file exactly
2. Check role assignment - user must have access
3. Refresh Finacle cache
4. Check deployment logs for errors
```

#### **Issue: Stored procedure not found**
```
Solution:
1. Verify procedure exists in database
2. Check schema name and procedure name spelling
3. Grant execute permissions to Finacle user
4. Test procedure independently in SQL Developer
```

#### **Issue: Parameters not working**
```
Solution:
1. Check parameter names match stored procedure
2. Verify parameter data types
3. Check @DBQUERY annotations
4. Test with hard-coded values first
```

#### **Issue: Permission denied during deployment**
```bash
# Solution: Set correct permissions
chmod 755 filename.jrxml
# Or for directory
chmod -R 755 directory_name/
```

#### **Issue: Report generates blank output**
```
Solution:
1. Verify stored procedure returns data
2. Check field mappings are correct
3. Test SQL query independently
4. Check for null value handling
5. Verify date formats match
```

---

## ?? Additional Resources

### **Official Documentation**
- [Finacle CBS Documentation](https://www.edgeverve.com/finacle/)
- [Jasper Reports Community](https://community.jaspersoft.com/)
- [iReport Designer Guide](http://jasperreports.sourceforge.net/ireport.html)
- [Oracle PL/SQL Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/)

### **Related Topics**
- Finacle Report Framework
- SPBx Stored Procedures
- Jasper Report Design Patterns
- Oracle Performance Tuning
- Unix/Linux Administration

---

## ?? Contributing

Contributions are welcome! Whether you have:
- Additional report examples
- Improved stored procedures
- Better design templates
- Documentation improvements
- Bug fixes or enhancements

**How to Contribute:**
1. Fork the repository
2. Create feature branch (`git checkout -b feature/NewFeature`)
3. Commit changes (`git commit -m 'Add NewFeature'`)
4. Push to branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

---

## ?? Contact & Support

**Author:** Bhushan R Chougule  
**Role:** Core Banking Solution Architect | Finacle Specialist

- ?? Email: chougulebhushan@gmail.com
- ?? LinkedIn: [@bhushanv05](https://linkedin.com/in/bhushanv05)
- ?? GitHub: [@Bhushanv05](https://github.com/Bhushanv05)
- ?? Portfolio: [View Projects](https://gamma.app/docs/Bhushan-R-Chougule-fmvzjcuswyv35mp)

---

## ?? License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## ?? Acknowledgments

- Finacle CBS Platform by EdgeVerve Systems
- Jaspersoft Community for excellent reporting tools
- The Satara DCC Bank for the implementation experience
- Oracle Database documentation
- Open-source community contributors

---

## ?? Project Statistics

- ?? **Based on:** 12+ years of Finacle CBS experience
- ?? **Production Reports:** 300+ reports deployed
- ?? **Users Served:** 2.1M+ customer accounts
- ?? **Branches:** 300+ branch deployment
- ? **Performance:** Sub-second report generation
- ?? **Accuracy:** 99.97% data accuracy

---

## ?? Related Projects

- [Core Banking PL/SQL Utilities](https://github.com/Bhushanv05/core-banking-plsql-utilities)
- [Banking Automation Scripts](https://github.com/Bhushanv05/banking-automation-scripts)
- [NPCI Payment Integration](https://github.com/Bhushanv05/npci-payment-integration)

---

<div align="center">

### ? Star this repository if you find it helpful!

**Made with ?? for the Finacle CBS & Banking Community**

![Visitors](https://komarev.com/ghpvc/?username=Bhushanv05-jasper&color=green&style=flat-square&label=Repository+Views)

---

**"Empowering banking professionals with practical, production-ready solutions"**

</div>
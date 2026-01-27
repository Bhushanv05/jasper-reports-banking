Technical Procedure: Finacle Report (FinRpt)
Configuration
System: Finacle Core | Design Tool: iReport Designer
I. Report Design & Data Definition
1. Launch iReport Wizard
Navigate to Plugin → Report Wizard
2. Select Framework
Choose Custom → SPBx proc
3. Connectivity
Choose the target Database Connection → Select Template Layout
4. Identification
Provide the formal Report Name in the Settings tab
5. Schema Mapping
Navigate to Data Fields → ADD Fields
Open Query Wizard → Select Database
Find Object → Search for the specific Stored Procedure Name
Proceed via Next → ADD Input parameter
Click Finish to generate the .jrxml source
II. Configuration & Design Refinement
1. Table Mapping
Go to Plugin → Report Option → Tables
Use Select All to map fields and click OK
2. System Cleanup
Access Database Option and select Remove Custom
3. Static to Dynamic
Right-click Static Text labels and select Transform to textfield
III. Backend Deployment (Putty)
1. Server Access
Login to the Finacle Application Server via Putty
2. Directory Navigation
Move to the script and report directories using:
SCR → CD .. / → JRXML → Jasper → Rpt
3. File Permissions
Ensure the file has the correct execution rights by running:
chmod 755 filename
4. Execution
Run the deployment script:
deploy_finrpt.com [Your_Report_Name]
IV. Finacle Frontend Integration
1. Administrative Setup
Enter menu FINRPTC
2. Registration
Select ADD and enter:
Jasper Name: (Must match the deployed filename exactly)
Template Desc: Provide a clear description
3. Access Management
Use ADD Role-id to assign the report to user groups
4. Verification
Test the output using menu FINRPT
Important: Ensure all naming conventions match exactly between backend
deployment and frontend registration to avoid integration issues.

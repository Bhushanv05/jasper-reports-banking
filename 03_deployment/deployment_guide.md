# Finacle Report Deployment Guide

## Overview
This guide covers the complete backend deployment process for Finacle Jasper Reports.

## Prerequisites
- Access to Finacle application server
- Putty or SSH client
- Server credentials
- Report .jrxml file ready

## Step-by-Step Deployment

### 1. Connect to Server
```bash
ssh username@finacle-server-ip
```
Or use Putty with server IP and credentials.

### 2. Navigate to Report Directory
```bash
cd SCR
cd ../
cd JRXML
cd Jasper
cd Rpt
```

Alternative: Direct path
```bash
cd /path/to/finacle/jrxml/jasper/rpt
```

### 3. Upload JRXML File
Use one of these methods:
- **WinSCP:** GUI-based file transfer
- **SCP:** `scp report.jrxml username@server:/path/to/rpt/`
- **SFTP:** Interactive file transfer

### 4. Set File Permissions
```bash
chmod 755 LOAN_RECOVERY_DETAILS2001.jrxml
```

Verify permissions:
```bash
ls -l LOAN_RECOVERY_DETAILS2001.jrxml
```

Should show: `-rwxr-xr-x`

### 5. Deploy the Report
```bash
./deploy_finrpt.com LOAN_RECOVERY_DETAILS2001
```

Or if script is elsewhere:
```bash
/path/to/deploy_finrpt.com LOAN_RECOVERY_DETAILS2001
```

### 6. Verify Deployment
Check for success message in output.

Common success indicators:
- "Deployment successful"
- "Report compiled successfully"
- Return code 0

### 7. Check Logs (if deployment fails)
```bash
tail -f /path/to/logs/deployment.log
```

## Troubleshooting

### Permission Denied
```bash
# Solution: Fix permissions
chmod 755 filename.jrxml
```

### Script Not Found
```bash
# Solution: Find correct path
find / -name "deploy_finrpt.com" 2>/dev/null
```

### Deployment Fails
1. Check file format (must be valid XML)
2. Verify stored procedure exists
3. Check database connectivity
4. Review error logs

## Next Steps
After successful deployment, proceed to frontend configuration (FINRPTC menu).

See: [Finacle Configuration Guide](../04_finacle_configuration/finacle_report_configuration_guide.md)


directory 'c:\Setup\SQL' do
  action :create
  recursive true
end
log "#{cookbook_name}::Directory c:\\Setup\\SQL Created successfully"

remote_file 'c:\setup\sql\SQLBackup.zip' do
  source node['BIZTALK']['SQL_XREF_Backup']
  action :create_if_missing
end
log "#{cookbook_name}::Downloaded XREF SQL Backup as C:\\setup\\sql\\SQLBackup.zip successfully"

powershell_script 'Unzip SQL Backup' do
  code <<-EOH
    $BackUpPath = "C:\\setup\\sql\\sqlbackup.zip"
    $Destination = "C:\\setup\\sql"
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)

   [System.IO.File]::WriteAllText("c:\\setup\\sql\\_chefUnzip.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\sql\\_chefUnzip.lock"))'
end

powershell_script 'Restoring XREF Database' do
  code <<-EOH

         $computer = $env:COMPUTERNAME
        Import-Module SQLPS -DisableNameChecking

        # Connect to the specified instance
        $srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $computer

        # Get the default file and log locations
        # (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
        $fileloc = $srv.Settings.DefaultFile
        $logloc = $srv.Settings.DefaultLog
        if ($fileloc.Length -eq 0) {
            $fileloc = $srv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $srv.Information.MasterDBLogPath
            }

        # Identify the backup file to use, and the name of the database copy to create
        $bckfile = "C:\\Setup\\SQL\\SQLBAK\\ESB_Ops^20160818^144152^MS2.bak"
        $dbname = 'ESB_Ops'

        # Build the physical file names for the database copy
        $dbfile = $fileloc + $dbname + '_Data.mdf'
        $logfile = $logloc + $dbname + '_Log.ldf'

        # Use the backup file name to create the backup device
        $bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')

        # Create the new restore object, set the database name and add the backup device
        $rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
        $rs.Database = $dbname
        $rs.Devices.Add($bdi)

        # Get the file list info from the backup file
        $fl = $rs.ReadFileList($srv)
        foreach ($fil in $fl) {
            $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
            $rsfile.LogicalFileName = $fil.LogicalName
            if ($fil.Type -eq 'D'){
                $rsfile.PhysicalFileName = $dbfile
                }
            else {
                $rsfile.PhysicalFileName = $logfile
                }
            $rs.RelocateFiles.Add($rsfile)
            }

        $rs.ReplaceDatabase = $true
        $rs.NoRecovery = $false

        # Restore the database
         $rs.SqlRestore($srv)
         write-host "ESB_Ops Database restored"


$dbname = 'ESB_XREF'

# Build the physical file names for the database copy
$dbfile = $fileloc + $dbname + '_Data.mdf'
$logfile = $logloc + $dbname + '_Log.ldf'

$bckfile = "C:\\Setup\\SQL\\SQLBAK\\ESB_XREF^20160818^144152^MS2.bak"
 $bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')

        # Create the new restore object, set the database name and add the backup device
        $rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
        $rs.Database = $dbname
        $rs.Devices.Add($bdi)

        # Get the file list info from the backup file
        $fl = $rs.ReadFileList($srv)
        foreach ($fil in $fl) {
            $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
            $rsfile.LogicalFileName = $fil.LogicalName
            if ($fil.Type -eq 'D'){
                $rsfile.PhysicalFileName = $dbfile
                }
            else {
                $rsfile.PhysicalFileName = $logfile
                }
            $rs.RelocateFiles.Add($rsfile)
            }

        $rs.ReplaceDatabase = $true
        $rs.NoRecovery = $false

        # Restore the database
        $rs.SqlRestore($srv)
        write-host "ESB_Xref Database Restored"

    [System.IO.File]::WriteAllText("c:\\setup\\sql\\_chefXRefRestored.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\sql\\_chefXRefRestored.lock"))'
end
log "#{cookbook_name}::XREF SQL Databases restored"

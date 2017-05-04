
    param(
  [Parameter(Position=0,Mandatory=$true,HelpMessage="User Name")]
  [Alias("u")]
  [string]$User,

  [Parameter(Position=1,HelpMessage="Domain of the User")]
  [Alias("d")]
  [string]$Domain,

  [Parameter(Position=2,Mandatory=$true,HelpMessage="Password for the given account")]
  [Alias("p")]
  [string]$Password,

   [Parameter(Position=3,HelpMessage="Fill Path to SQL Iso File")]
  [Alias("iso")]
  [string]$IsoFile
)

    #$creds = New-Object System.Management.Automation.PSCredential ("$Domain\$User", (ConvertTo-SecureString $Password -AsPlainText -Force))

    if (![System.IO.File]::Exists("D:\\Program Files\\Microsoft SQL Server\\MSSQL12.MSSQLSERVER\\MSSQL\\Binn\\sqlservr.exe"))
    {
        $sqlIsoFile = $IsoFile
        $sqlMountResult = (Mount-DiskImage $sqlIsoFile -PassThru)
        $sqlDriveLetter = ($sqlMountResult | Get-Volume).Driveletter
        $sqlDrive = $sqlDriveLetter + ":"
        cd $sqlDrive

        #start-Process -filePath ".\\setup.exe" -Credential $creds -argumentList "/q /ACTION=Install /UpdateEnabled=false /ConfigurationFile=c:\\setup\\SQL\\configuration.ini /IACCEPTSQLSERVERLICENSETERMS=true /RSInstallMode=FilesOnlyMode" -wait
        start-Process -filePath ".\\setup.exe" -argumentList "/q /ACTION=Install /UpdateEnabled=false /ConfigurationFile=c:\\setup\\SQL\\configuration.ini /IACCEPTSQLSERVERLICENSETERMS=true" -wait

        dismount-diskimage $sqlIsoFile
    }

param(
  [Parameter(Position=0,Mandatory=$true,HelpMessage="SQL Server Name")]
  [Alias("sql")]
  [string]$SqlServer
  )


# this needs to run as the domain account
Write-host "Getting BizMgmtDb Server Name"
$btsConnectionString = "server=.;database=BizTalkMgmtDb;Integrated Security=SSPI;"
$btsDBServer =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBServer
$btsMgmtDB =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName
$btsConnectionString = "server="+$btsDBServer+";database="+$btsMgmtDB+";Integrated Security=SSPI"
  
Write-Host "Loading Powershell provider for BizTalk snap-in"
  
$InitializeDefaultBTSDrive = $false
Add-PSSnapin -Name BizTalkFactory.Powershell.Extensions
  
Write-Host $btsDBServer
New-PSDrive -Name BizTalk -Root BizTalk:\ -PsProvider BizTalk -Instance $btsDBServer -Database $btsMgmtDB

Write-Host "Switch to the default BizTalk drive"
Set-Location -Path BizTalk:

$configFile = 'c:\setup\bts\BizTalkGroupSettings.xml'
$computer = $env:COMPUTERNAME
$sqlName = $SqlServer
$featuresFileContent = [System.IO.File]::ReadAllText($configFile)
       
write-host "Replacing SQL Server Name: $sqlName in group settings File"
$_updatedContent = $featuresFileContent.Replace("@sqlServer", "$sqlName")

write-host "Replacing BizTalk Server Name: $computer in group settings file"
$updatedContent = $_updatedContent.Replace("@btsServer", "$computer")

write-host "Creating group-settings.xml file"
$configFile = 'c:\setup\bts\group-settings.xml'        
[System.IO.File]::WriteAllText($configFile, $updatedContent)

Write-Host "Importing BizTalk Group Settings"
Import-GroupSettings -Path BizTalk:\ -Source c:\setup\bts\group-settings.xml

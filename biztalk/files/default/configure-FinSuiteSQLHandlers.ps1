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
  

Write-Host "Checking BizTalk Adapter SQL Handlers"
 Set-Location -Path "Biztalk:\Platform Settings\Adapters\SQL"

$FSPSnd32AdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "SQL Send Handler (FSPSnd32AdapterHost)"}
if($FSPSnd32AdapterFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPSnd32Adapter Host Send SQL Handler"
       New-Item -Path 'SQL Send Handler (FSPSnd32AdapterHost)' -HostName FSPSnd32AdapterHost -Direction Send       
}

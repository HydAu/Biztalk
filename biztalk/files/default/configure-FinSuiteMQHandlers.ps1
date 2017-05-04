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

Write-Host "Checking BizTalk Adapter MQSeries Handlers"
  
Set-Location -Path "BizTalk:\Platform Settings\Adapters\MQSeries"

$Handler = Get-ChildItem | Where-Object{$_.Name -eq "MQSeries Send Handler (FSPSndAdapterHost)"}
if($Handler.Name -eq $null)
{
       Write-Host "Creating FSPSndAdapter Host Send MQSeries Handler"
       New-Item -Path 'MQSeries Send Handler (FSPSndAdapterHost)' -HostName FSPSndAdapterHost -Direction Send       
}
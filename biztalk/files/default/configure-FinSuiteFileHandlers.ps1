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
  

Write-Host "Checking BizTalk Adapter FILE Handlers"
 Set-Location -Path "Biztalk:\Platform Settings\Adapters\FILE"
 

$FSPLargeDataHostFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Send Handler (FSPLargeDataHost)"}
if($FSPLargeDataHostFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPLargeDataHost Send File Handler"
       New-Item -Path 'FILE Send Handler (FSPLargeDataHost)' -HostName FSPLargeDataHost -Direction Send       
}


$FSPSndAdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Send Handler (FSPSndAdapterHost)"}
if($FSPSndAdapterFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPSndAdapter Send File Handler"
       New-Item -Path 'FILE Send Handler (FSPSndAdapterHost)' -HostName FSPSndAdapterHost -Direction Send       
}

$FSPRcvLargeDataHostFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Receive Handler (FSPLargeDataHost)"}
if($FSPRcvLargeDataHostFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPLargeDataHost Receive File Handler"
       New-Item -Path 'FILE Receive Handler (FSPLargeDataHost)' -HostName FSPLargeDataHost -Direction Receive       
}


$FSPRcvAdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Receive Handler (FSPRcvAdapterHost)"}
if($FSPRcvAdapterFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPRcvAdapterHost Receive File Handler"
       New-Item -Path 'FILE Receive Handler (FSPRcvAdapterHost)' -HostName FSPRcvAdapterHost -Direction Receive       
}

$FSP32RcvLargeDataHostFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Receive Handler (FSP32LargeDataHost)"}
if($FSP32RcvLargeDataHostFileHandler.Name -eq $null)
{
       Write-Host "Creating FSP32LargeDataHost Receive File Handler"
       New-Item -Path 'FILE Receive Handler (FSP32LargeDataHost)' -HostName FSP32LargeDataHost -Direction Receive       
}


$FSPRcv32AdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Receive Handler (FSPRcv32AdapterHost)"}
if($FSPRcv32AdapterFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPRcv32AdapterHost Receive File Handler"
       New-Item -Path 'FILE Receive Handler (FSPRcv32AdapterHost)' -HostName FSPRcv32AdapterHost -Direction Receive       
}

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
  
Write-Host "Checking BizTalk Adapter WCF-Custom Handlers"
Set-Location -Path "BizTalk:\Platform Settings\Adapters\WCF-Custom"


$FSPSnd32AdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Send Handler (FSPSnd32AdapterHost)"}
if($FSPSnd32AdapterFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPSnd32Adapter Host Send WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Send Handler (FSPSnd32AdapterHost)' -HostName FSPSnd32AdapterHost -Direction Send  
       Set-ItemProperty -Path 'WCF-Custom Send Handler (FSPSnd32AdapterHost)' -Name 'Default' -Value 'True'     
}

$FSPSndAdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Send Handler (FSPSndAdapterHost)"}
if($FSPSndAdapterFileHandler.Name -eq $null)
{
       Write-Host "Creating FSPSndAdapter Host Send WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Send Handler (FSPSndAdapterHost)' -HostName FSPSndAdapterHost -Direction Send
}


$Handler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Send Handler (FSPLargeDataHost)"}
if($Handler.Name -eq $null)
{
       Write-Host "Creating FSPLargeData Host Send WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Send Handler (FSPLargeDataHost)' -HostName FSPLargeDataHost -Direction Send
}


$Handler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Send Handler (FSP32LargeDataHost)"}
if($Handler.Name -eq $null)
{
       Write-Host "Creating FSP32LargeData Host Send WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Send Handler (FSP32LargeDataHost)' -HostName FSP32LargeDataHost -Direction Send
}

$Handler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Receive Handler (FSPLargeDataHost)"}
if($Handler.Name -eq $null)
{
       Write-Host "Creating FSPLargeData Host Receive WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Receive Handler (FSPLargeDataHost)' -HostName FSPLargeDataHost -Direction Receive
}


$Handler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Receive Handler (FSPRcvAdapterHost)"}
if($Handler.Name -eq $null)
{
       Write-Host "Creating FSPRcvAdapter Host Receive WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Receive Handler (FSPRcvAdapterHost)' -HostName FSPRcvAdapterHost -Direction Receive
}

$Handler = Get-ChildItem | Where-Object{$_.Name -eq "WCF-Custom Receive Handler (FSPRcv32AdapterHost)"}
if($Handler.Name -eq $null)
{
       Write-Host "Creating FSPRcv32Adaper Host Receive WCF-Custom Handler"
       New-Item -Path 'WCF-Custom Receive Handler (FSPRcv32AdapterHost)' -HostName FSPRcv32AdapterHost -Direction Receive
}


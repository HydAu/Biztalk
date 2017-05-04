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
  
Write-Host "Importing BizTalk Group Settings"
# Import-GroupSettings -Path BizTalk:\\ -Source c:\\setup\\bts\\BizTalkGroupSettings.xml
 
Write-host "Getting Default BizTalk Applicaton Users Group Name"
$btsApplicationGroupName = Get-ItemProperty -Path '\Platform Settings\Hosts\BizTalkServerApplication' -Name 'NtGroupName'
$btsIsolatedHostGroupName = Get-ItemProperty -Path '\Platform Settings\Hosts\BizTalkServerIsolatedHost' -Name 'NtGroupName'

Write-Host "Start Checking BizTalk Hosts"
 Set-Location -Path "Biztalk:\Platform Settings\Hosts"
  
write-host "Check if FSPRcvAdapterHost Host Exists"
$FSPRcvAdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "FSPRcvAdapterHost"}
if($FSPRcvAdapterHost.Name -eq $null)
{
       Write-Host "Creating FSPRcvAdapter Hosts"
       New-Item FSPRcvAdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSPRcvAdapterHost -Name 'Is32BitOnly' -Value 'False'
}
  

write-host "Check if FSPSndAdapterHost Host Exists"
$FSPSndAdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "FSPSndAdapterHost"}
if($FSPSndAdapterHost.Name -eq $null)
{
       Write-Host "Creating FSPSndAdapter Hosts"
       New-Item FSPSndAdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSPSndAdapterHost -Name 'Is32BitOnly' -Value 'False'
}
  
  write-host "Check if FSPOrchHost Host Exists"
$FSPOrchHost = Get-ChildItem | Where-Object{$_.Name -eq "FSPOrchHost"}
if($FSPOrchHost.Name -eq $null)
{
       Write-Host "Creating FSPOrch Hosts"
       New-Item FSPOrchHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSPOrchHost -Name 'Is32BitOnly' -Value 'False'
}

write-host "Check if FSPRcv32AdapterHost Host Exists"
$FSPRcv32AdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "FSPRcv32AdapterHost"}
if($FSPRcv32AdapterHost.Name -eq $null)
{
       Write-Host "Creating FSPRcv32Adapter Hosts"
       New-Item FSPRcv32AdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSPRcv32AdapterHost -Name 'Is32BitOnly' -Value 'True'
}
  


write-host "Check if FSP32OrchHost Host Exists"
$FSP32OrchHost = Get-ChildItem | Where-Object{$_.Name -eq "FSP32OrchHost"}
if($FSP32OrchHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSP32OrchHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSP32OrchHost -Name 'Is32BitOnly' -Value 'True'
}

write-host "Check if FSPLargeDataHost Host Exists"
$FSPLargeDataHost = Get-ChildItem | Where-Object{$_.Name -eq "FSPLargeDataHost"}
if($FSPLargeDataHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSPLargeDataHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSPLargeDataHost -Name 'Is32BitOnly' -Value 'False'
       Set-ItemProperty -Path FSPLargeDataHost -Name 'ProcessMemoryThreshold' -Value '75'
}

write-host "Check if FSP32LargeDataHost Host Exists"
$FSP32LargeDataHost = Get-ChildItem | Where-Object{$_.Name -eq "FSP32LargeDataHost"}
if($FSP32LargeDataHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSP32LargeDataHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSP32LargeDataHost -Name 'Is32BitOnly' -Value 'True'
       Set-ItemProperty -Path FSP32LargeDataHost -Name 'ProcessMemoryThreshold' -Value '75'
}
  
  
write-host "Check if FSPSnd32AdapterHost Host Exists"
$FSPSnd32AdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "FSPSnd32AdapterHost"}
if($FSPSnd32AdapterHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSPSnd32AdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
       Set-ItemProperty -Path FSPSnd32AdapterHost -Name 'Is32BitOnly' -Value 'True'
       Set-ItemProperty -Path FSPSnd32AdapterHost -Name 'ProcessMemoryThreshold' -Value '75'
}
  
  $BTSDefault = Get-ChildItem | Where-Object{$_.Name -eq "BizTalkServerApplicaiton"}
if($BTSDefault.Name -ne $null)
{
       Write-Host "Updating BizTalk Server Application Hosts"
       Set-ItemProperty -Path BizTalkServerApplication -Name 'ThreadPoolSize' -Value '50'       
}
  
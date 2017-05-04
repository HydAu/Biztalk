  param(
  [Parameter(Position=0,Mandatory=$true,HelpMessage="User Name")]
  [Alias("u")]
  [string]$User,

  [Parameter(Position=1,HelpMessage="Domain of the User")]
  [Alias("d")]
  [string]$Domain,

  [Parameter(Position=2,Mandatory=$true,HelpMessage="Password for the given account")]
  [Alias("p")]
  [string]$Password
  )

 $creds = New-Object System.Management.Automation.PSCredential ("$Domain\$User", (ConvertTo-SecureString $Password -AsPlainText -Force))

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
 Set-Location -Path "Biztalk:\Platform Settings\Host Instances"

$computer = $env:COMPUTERNAME

write-host "Check if FSPRcvAdapterHost Instance Instance Exists"
$FSPRcvAdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSPRcvAdapterHost $computer"}
if($FSPRcvAdapterHost.Name -eq $null)
{
       Write-Host "Creating FSPRcvAdapter Hosts Instance"
       New-Item FSPRcvAdapterHost -credentials $creds -RunningServer $computer -HostName 'FSPRcvAdapterHost'

}

write-host "Check if FSPSndAdapterHost Instance Exists"
$FSPSndAdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSPSndAdapterHost $computer"}
if($FSPSndAdapterHost.Name -eq $null)
{
       Write-Host "Creating FSPSndAdapter Hosts Instance"
       New-Item FSPSndAdapterHost  -credentials $creds -RunningServer $computer -HostName 'FSPSndAdapterHost'
}

write-host "Check if FSPOrchHost Instance Exists"
$FSPOrchHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSPOrchHost $computer" }
if($FSPOrchHost.Name -eq $null)
{
       Write-Host "Creating FSPOrch Hosts"
       New-Item FSPOrchHost -credentials $creds -RunningServer $computer -HostName 'FSPOrchHost'
}

write-host "Check if FSPRcv32AdapterHost Instance Exists"
$FSPRcv32AdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSPRcv32AdapterHost $computer" }
if($FSPRcv32AdapterHost.Name -eq $null)
{
       Write-Host "Creating FSPRcv32Adapter Hosts"
       New-Item FSPRcv32AdapterHost -credentials $creds -RunningServer $computer -HostName 'FSPRcv32AdapterHost'
}

write-host "Check if FSP32OrchHost Instance Exists"
$FSP32OrchHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSP32OrchHost $computer" }
if($FSP32OrchHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSP32OrchHost -credentials $creds -RunningServer $computer -HostName 'FSP32OrchHost'
}

write-host "Check if FSPLargeDataHost Instance Exists"
$FSPLargeDataHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSPLargeDataHost $computer" }
if($FSPLargeDataHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSPLargeDataHost -credentials $creds -RunningServer $computer -HostName 'FSPLargeDataHost'
}

write-host "Check if FSP32LargeDataHost Instance Exists"
$FSP32LargeDataHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSP32LargeDataHost $computer" }
if($FSP32LargeDataHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSP32LargeDataHost -credentials $creds -RunningServer $computer -HostName 'FSP32LargeDataHost'
}


write-host "Check if FSPSnd32AdapterHost Instance Exists"
$FSPSnd32AdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "Microsoft BizTalk Server FSPSnd32AdapterHost $computer" }
if($FSPSnd32AdapterHost.Name -eq $null)
{
       Write-Host "Creating FSP32Orch Hosts"
       New-Item FSPSnd32AdapterHost -credentials $creds -RunningServer $computer -HostName 'FSPSnd32AdapterHost'
}

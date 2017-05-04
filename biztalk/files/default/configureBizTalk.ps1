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

# $creds = New-Object System.Management.Automation.PSCredential ("$Domain\$User", (ConvertTo-SecureString $Password -AsPlainText -Force))

if ( ( (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName -eq $null  ) )
{
  write-host "Starting BizTalk Configuration..."

  cd "C:\\Program Files (x86)\\Microsoft BizTalk Server 2013 R2"        
  # start-Process -filePath ".\\configuration.exe" -Credential $creds -argumentList "/s c:\\setup\\bts\\biztalkfeatures.xml /l c:\\setup\\bts\\configuration.log /noprogressbar" -wait        
    start-Process -filePath ".\\configuration.exe" -argumentList "/s c:\\setup\\bts\\biztalkfeatures.xml /l c:\\setup\\bts\\configuration.log /noprogressbar" -wait        
  write-host "BizTalk Configuration complete"


}  
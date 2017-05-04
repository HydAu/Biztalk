param(
  [Parameter(Position=0,Mandatory=$true,HelpMessage="User Name")]
  [Alias("u")]
  [string]$User,
  [Parameter(Position=1,HelpMessage="Domain of the User")]
  [Alias("d")]
  [string]$Domain
)

NET LOCALGROUP Administrators /ADD "$Domain\$User"

require 'spec_helper'

# configureAppEventLogCheck = <<-EOH
#   (Get-EventLog -list | where {$_.Log -eq "Application"}).MaximumKilobytes -eq 40960
# EOH

# describe  powershell(configureAppEventLogCheck) do
#   # Serverspec examples can be found at
#   # http://serverspec.org/resource_types.html
#   its('stdout') { should eq true }

# end

# disableFirewallCheck = <<-EOH
#   (get-netfirewallprofile -profile domain,public,private).enabled -eq true
# EOH

# describe  powershell(disableFirewallCheck) do
#   # Serverspec examples can be found at
#   # http://serverspec.org/resource_types.html
#   its('stdout') { should eq true }

# end

# disableEnhancedSecurityCheck = <<-EOH
#   (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}").IsInstalled -eq 0
# EOH

# describe powershell(disableEnhancedSecurityCheck) do
#   its('stdout') {should be true }
# end

# disableIPv6Check = <<-EOH
#   (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters").DisabledComponents
# EOH

# describe powershell(disableIPv6Check) do
#   its('stdout') {should be true }
# end

# disableUACCheck = <<-EOH
#   (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system").EnableLUA -eq 0
# EOH

# describe powershell(disableUACCheck) do
#   its('stdout') {should be true }
# end

# disableUACCheck = <<-EOH
#   (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system").EnableLUA -eq 0
# EOH

# describe powershell(disableUACCheck) do
#   its('stdout') {should be true }
# end

# biztalkInstalledCheck = <<-EOH
#   ( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0")
# EOH

# describe powershell(biztalkInstalledCheck) do
#   its('stdout') {should be true }
# end

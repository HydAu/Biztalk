reboot 'now' do
  action :nothing
  reason 'Joining Domain'
  delay_mins 2
end

directory 'c:\Setup' do
  recursive true
  action :create
end

# basically a RunAs ...
cookbook_file 'c:\\setup\\Add-DomainUserToLocalAdminGroup.ps1' do
  source 'Add-DomainUserToLocalAdminGroup.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Add-DomainUserToLocalAdminGroup.ps1 Silently Powershell script downloaded"

name_secret "#{node['DeploymentStage']}/#{node['AppName']}/#{node['Role']}/secret1" do
  destination 'secret1'
end

template 'C:\\setup\\JoinDomain.ps1' do
  source 'JoinDomainScript.ps1.erb'
  action :create_if_missing
  variables lazy {
    {
      domain: node.run_state['secret1']['BTS_InstallerAccountDomain'],
      domainname: node.run_state['secret1']['BTS_SvcHostAccountDomain'],
      account: node.run_state['secret1']['BTS_InstallerAccount'],
      password: node.run_state['secret1']['BTS_InstallerAccountPassword']
    }
  }
end
log "#{cookbook_name}::Join Domain script Created"

powershell_script 'Add domain' do
  cwd 'C:\\Setup'
  code <<-EOH
  .\\JoinDomain.ps1
  Start-Sleep -Seconds 15
  EOH
  guard_interpreter :powershell_script
end
log "#{cookbook_name}::Added Machine to the domain Successfully"

powershell_script 'Add Domain Installer Account To Local Admins' do
  code <<-EOH
    # we're in a domain

    NET LOCALGROUP Administrators /ADD "#{node['BIZTALK']['BTS_InstallerAccountDomain']}\\#{node['BIZTALK']['BTS_InstallerAccount']}"

    [System.IO.File]::WriteAllText("c:\\setup\\_chefDomainUsersLocal.lock", "complete")

  EOH
  guard_interpreter :powershell_script
  notifies :reboot_now, 'reboot[now]', :immediately
  #  not_if '[System.IO.File]::Exists("D:\\Program Files\\Microsoft SQL Server\\MSSQL12.MSSQLSERVER\\MSSQL\\Binn\\sqlservr.exe")'
end
log "#{cookbook_name}::Added Domain Installer to Local Admin group Successfully"

# powershell_script 'Add Domain Installer Account To Local Admins' do
#  code <<-EOH
#  $domain = (Get-WmiObject win32_computersystem).Domain
# $computer = (Get-WmiObject win32_computersystem).DNSHostName
# $FQDN= "$computer.$domain"

# check to make sure we're in a domain
#  if($domain -ne $null)
#  {
# we're in a domain

#    NET LOCALGROUP Administrators /ADD "#{node['BIZTALK']['BTS_InstallerAccountDomain']}\\#{node['BIZTALK']['BTS_InstallerAccount']}"

#    [System.IO.File]::WriteAllText("c:\\setup\\_chefDomainUsersLocal.lock", "complete")

#  }
#  EOH
#  guard_interpreter :powershell_script
#  notifies :reboot_now, 'reboot[now]', :immediately
#  not_if '[System.IO.File]::Exists("D:\\Program Files\\Microsoft SQL Server\\MSSQL12.MSSQLSERVER\\MSSQL\\Binn\\sqlservr.exe")'
# end
# log "#{cookbook_name}::Added Domain Installer to Local Admin group Successfully"

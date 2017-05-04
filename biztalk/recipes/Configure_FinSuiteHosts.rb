
include_recipe "#{cookbook_name}::Folders"

registry_key 'HKEY_LOCAL_MACHINE\Software\Microsoft\BizTalk Server\3.0\Administration' do
  values [{
    name: 'TransformThreshold',
    type: :dword,
    data: 33_554_432
  }]
  action :create_if_missing
end

template 'c:\setup\bts\BizTalkGroupSettings.xml' do
  source 'BizTalkGroupSettings.erb'
  action :create_if_missing
end
log "#{cookbook_name}::BizTalk Group Settings File from template copied to C:\\setup\\bts\\BizTalkGroupSettings.xml successfully"

template 'c:\setup\bts\Microsoft.Practices.Esb.Bindings.xml' do
  source 'microsoft.practices.esb.bindings.erb'
  action :create_if_missing
end
log "#{cookbook_name}::Microsoft Practices ESB Binding File from template copied to C:\\setup\\bts\\Microsoft.Practices.Esb.Binding.xml successfully"

powershell_script 'Configure Local XREF Groups' do
  code <<-EOH
        $computer = $env:COMPUTERNAME
        $ADSI = [ADSI]("WinNT://$computer")

       try { $glAdmin = $ADSI.psbase.children.find('app_name_GL_XREF_Admin', 'Group') }
       catch { $glAdmin = $null }

        if($glAdmin -eq $null)
        {
          $glAdmin = $ADSI.Create('Group', 'app_name_GL_XREF_Admin')
          $glAdmin.SetInfo()
        }

        try{ $glRO = $ADSI.psbase.children.find('app_name_GL_XREF_RO', 'Group') }
        catch { $glRO = $null }
        if($glRO -eq $null)
        {
          $glRO = $ADSI.Create('Group', 'app_name_GL_XREF_RO')
          $glRO.SetInfo()
        }

        try { $apAdmin = $ADSI.psbase.children.find('app_name_AP_XREF_Admin', 'Group')}
        catch { $apAdmin = $null }
        if($apAdmin -eq $null)
        {
          $apAdmin = $ADSI.Create('Group', 'app_name_AP_XREF_Admin')
          $apAdmin.SetInfo()
        }

        try { $apRW = $ADSI.psbase.children.find('app_name_AP_XREF_RW', 'Group')}
        catch { $apRW = $null }
        if($apRW -eq $null)
        {
          $apRW = $ADSI.Create('Group', 'app_name_AP_XREF_RW')
          $apRW.SetInfo()
        }


    # Have to add domain accounts to local group - must test first
    # $userName = "#{node['BIZTALK']['BTS_SvcHostAccount']}"
    # $isoUserName = "#{node['BIZTALK']['BTS_SvcIsoHostAccount']}"

    # NET LOCALGROUP "app_name_AP_XREF_Admin" $userName /ADD
    # NET LOCALGROUP "app_name_AP_XREF_Admin" $isoUserName /ADD
    # NET LOCALGROUP "app_name_GL_XREF_Admin" $userName /ADD
    # NET LOCALGROUP "app_name_GL_XREF_Admin" $isoUserName /ADD

    # NET LOCALGROUP "app_name_AP_XREF_Admin" $env:USERNAME /ADD
    # NET LOCALGROUP "app_name_GL_XREF_Admin" $env:USERNAME /ADD

        [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefXREF.lock", "complete")

    EOH

  # $userName = "app_name_fin_xref_dev"
  #     $userPassword = "#{node['BIZTALK']['BTS_LocalSvcHostAccountPassword']}"

  #     try { $apUser = $ADSI.psbase.children.find('app_name_fin_xref_dev', 'User')}
  #     catch { $apUser = $null }
  #     if($apUser -eq $null)
  #     {
  #      NET USER $userName $userPassword /ADD
  #      NET LOCALGROUP "administrators" $userName /ADD
  #     }

  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefXREF.lock"))'
  #  not_if '(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0")'
end
log "#{cookbook_name}::XREF Local Groups Configured"

# New-Item MySqlHost -credentials $creds -RunningServer 'WIN-1P5D0P30MP5' -HostName 'SQL32Host'

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteHosts.ps1' do
  source 'configure-FinSuiteHosts.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteHosts.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite Hosts' do
  architecture :i386
  code <<-EOH

  c:\\setup\\bts\\Configure-FinSuiteHosts.ps1
  Write-Host "End Checking BizTalk Hosts"

  [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefFinHostConfigured.lock", "complete")

  EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefFinHostConfigured.lock") )'
end
log "#{cookbook_name}::FSP SOA FinSuite Hosts Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteHostsInstances.ps1' do
  source 'configure-FinSuiteHostsInstances.ps1'
  action :create_if_missing
end
log "#{cookbook_name}::Configure-FinSuiteHostsInstances.ps1 Silently Powershell script downloaded"

name_secret "#{node['DeploymentStage']}/#{node['AppName']}/#{node['Role']}/secret1" do
  destination 'secret1'
end

template 'C:\\setup\\bts\\ConfigureFinSuiteHostsInstances.ps1' do
  source 'ConfigureFinSuiteHostsInstances.ps1.erb'
  variables lazy {
    {
      username: node.run_state['secret1']['BTS_SvcHostAccount'],
      userpassword: node.run_state['secret1']['BTS_SvcHostAccountPassword'],
      userdomain: node.run_state['secret1']['BTS_SvcHostAccountDomain']
    }
  }
end

powershell_script 'Configure FinSuite Host Instances' do
  architecture :i386
  code <<-EOH

  "c:\\setup\\bts\\ConfigureFinSuiteHostsInstances.ps1"

  EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefFinHostInstancesConfigured.lock") )'
end
log "#{cookbook_name}::FSP SOA FinSuite Host Instances Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteFileHandlers.ps1' do
  source 'configure-FinSuiteFileHandlers.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteFileHandlers.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite File Handlers' do
  architecture :i386
  code <<-EOH
  c:\\setup\\bts\\Configure-FinSuiteFileHandlers.ps1
  Write-Host "End BizTalk Adapter FILE Handlers"
  [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefFileHandler.lock", "complete")
  EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefFileHandler.lock"))'
end
log "#{cookbook_name}::FSP SOA FinSuite File Handlers Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteSQLHandlers.ps1' do
  source 'configure-FinSuiteSQLHandlers.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteSQLHandlers.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite SQL Handlers' do
  architecture :i386
  code <<-EOH
    c:\\setup\\bts\\Configure-FinSuiteSQLHandlers.ps1
  Write-Host "End BizTalk Adapter SQL Handlers"
[System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefSQLHandler.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefSQLHandler.lock"))'
end
log "#{cookbook_name}::FSP SOA FinSuite SQL Handlers Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteWCFHandlers.ps1' do
  source 'configure-FinSuiteWCFHandlers.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteWCFHandlers.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite WCF-Custom Handlers' do
  architecture :i386
  code <<-EOH
   c:\\setup\\bts\\Configure-FinSuiteWCFHandlers.ps1
Write-Host "End BizTalk Adapter WCF-Custom Handlers"
   [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefWCFHandler.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefWCFHandler.lock"))'
end
log "#{cookbook_name}::FSP SOA FinSuite WCF-Custom Handlers Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteMQHandlers.ps1' do
  source 'configure-FinSuiteMQHandlers.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteMQHandlers.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite MQSeries Handlers' do
  architecture :i386
  code <<-EOH
  c:\\setup\\bts\\Configure-FinSuiteMQHandlers.ps1
Write-Host "End BizTalk Adapter MQSeries Handlers"
   [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefMQSeriesHandler.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefMQSeriesHandler.lock"))'
end
log "#{cookbook_name}::FSP SOA FinSuite MQSeries Handlers Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteSFTPHandlers.ps1' do
  source 'configure-FinSuiteSFTPHandlers.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteSFTPHandlers.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite SFTP Handlers' do
  architecture :i386
  code <<-EOH
 c:\\setup\\bts\\Configure-FinSuiteSFTPHandlers.ps1
Write-Host "End BizTalk Adapter SFTP Handlers"
   [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefSFTPHandler.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefSFTPHandler.lock"))'
end
log "#{cookbook_name}::FSP SOA FinSuite SFTP Handlers Configured"

cookbook_file 'c:\\setup\\bts\\Configure-FinSuiteFTPHandlers.ps1' do
  source 'configure-FinSuiteFTPHandlers.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::Configure-FinSuiteFTPHandlers.ps1 Silently Powershell script downloaded"

powershell_script 'Configure FinSuite FTP Handlers' do
  architecture :i386
  code <<-EOH
 c:\\setup\\bts\\Configure-FinSuiteFTPHandlers.ps1
Write-Host "End BizTalk Adapter FTP Handlers"
Write-Host "Complete"
   [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefFTPHandler.lock", "complete")
    EOH
  guard_interpreter :powershell_script
  not_if '( [System.IO.File]::exists("c:\\setup\\bts\\_chefFTPHandler.lock") )'
end
log "#{cookbook_name}::FSP SOA FinSuite Hosts Configured"

cookbook_file 'c:\\setup\\bts\\import-GroupSettings.ps1' do
  source 'import_GroupSettings.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::import-GroupSettings.ps1 Silently Powershell script downloaded"

powershell_script 'import-GroupSettings' do
  architecture :i386
  code <<-EOH
    $btsDBServer =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBServer
    c:\\setup\\bts\\import-GroupSettings.ps1 -SqlServer $btsDbServer
    [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefGroupSettings.lock", "complete")
  EOH
  guard_interpreter :powershell_script
  not_if '( [System.IO.File]::exists("c:\\setup\\bts\\_chefGroupSettings.lock") )'
end
log "#{cookbook_name}::FSP Group Settings Imported"

# must do pgp import manually
# include_recipe "#{cookbook_name}::pgp"
# include_recipe "#{cookbook_name}::pgp_files"

include_recipe "#{cookbook_name}::zeke_scripts"
include_recipe "#{cookbook_name}::Biztalk_configurationfiles"
include_recipe "#{cookbook_name}::Biztalk_esbconfigfiles"
include_recipe "#{cookbook_name}::machine_config"


cookbook_file 'c:\\setup\\bts\\ConfigureBiztalk.ps1' do
  source 'configureBizTalk.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::ConfigureBiztalk.ps1 Silently Powershell script downloaded"

remote_file 'c:\setup\bts\DynamicServerName.txt' do
  source node['BIZTALK']['SQL_DynamicInstanceName']
  action :create_if_missing
end
log "#{cookbook_name}::Dynamic SQL Server Name to c:\\setup\\bts successfully"

name_secret "#{node['DeploymentStage']}/#{node['AppName']}/#{node['Role']}/secret1" do
  destination 'secret1'
end

powershell_script 'Configure Test BizTalk Instance' do
  code <<-EOH

        $userName = "#{node.run_state['secret1']['BTS_SvcHostAccount']}"
        $isoUserName = "#{node.run_state['secret1']['BTS_SvcIsoHostAccount']}"
        $userPassword = "#{node.run_state['secret1']['BTS_SvcHostAccountPassword']}"
        $isoUserPassword = "#{node.run_state['secret1']['BTS_SvcIsoHostAccountPassword']}"
        $userDomain = "#{node.run_state['secret1']['BTS_SvcHostAccountDomain']}"
        $isoUserDomain = "#{node.run_state['secret1']['BTS_SvcIsoHostAccountDomain']}"
        $btAdmin  = "#{node.run_state['secret1']['BTS_InstallerAccount']}"
        $btAdminPwd = "#{node.run_state['secret1']['BTS_InstallerAccountPassword']}"
        $btDomain = "#{node.run_state['secret1']['BTS_InstallerAccountDomain']}"

        $configFile = "#{node.run_state['secret1']['BTS_ServerFeaturesFile']}"

        write-host "Getting SQL Server Name from file"
        $sqlName = [System.IO.File]::ReadAllText("c:\\setup\\bts\\DynamicServerName.txt")
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("<Server>.</Server>", "<Server>$sqlName</Server>")
        [System.IO.File]::WriteAllText("c:\\setup\\bts\\biztalkfeatures.xml", $updatedContent)

 #       write-host "Adding user:  $userName  to local administrators group"
 #       NET USER $userName $userPassword /ADD
 #       NET LOCALGROUP 'administrators' '$userDomain\$userName' /ADD

  #      NET USER $isoUserName $isoUserPassword /ADD
  #      NET LOCALGROUP 'administrators' '$isoUserDomain\$isoUserName' /ADD

   #     $script = "c:\\setup\\bts\\ConfigureBizTalk.ps1"
   #     cd "c:\\setup\\bts"
   #     .\\ConfigureBizTalk.ps1 -User $btAdmin -Domain $btDomain -Password $btAdminPwd

        [System.IO.File]::WriteAllText("c:\\setup\\bts\\_btsConfigured.lock", "complete")

    EOH
  guard_interpreter :powershell_script
  not_if '( ( (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName -ne $null  ) -and ([System.IO.File]::exists("c:\\setup\\bts\\_btsConfigured.lock")) )'
end
log "#{cookbook_name}::BizTalk 2013 R2 Test Server Configured"

# windows_task 'configure BizTalk Remotely' do
#  user "#{node['BIZTALK']['BTS_InstallerAccountDomain']}\\#{node['BIZTALK']['BTS_InstallerAccount']}"
#  password node['BIZTALK']['BTS_InstallerAccountPassword']
#  cwd 'C:\\setup\\bts'
#  command ".\\ConfigureBizTalk.ps1 -User #{node['BIZTALK']['BTS_InstallerAccount']} -Domain #{node['BIZTALK']['BTS_InstallerAccountDomain']} -Password #{node['BIZTALK']['BTS_InstallerAccountPassword']}"
#  run_level :highest
#  frequency :minute
#  frequency_modifier 15
#  action :run
# end

template 'c:\setup\bts\ESBConfigurationTool.exe.config' do
  source 'esbconfigurationtool.exe.config.erb'
  action :create_if_missing
end

powershell_script 'Configure TEST BizTalk ESB Toolkit' do
  code <<-EOH

        move-item -path "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config.old"

        write-host "Updating ESB Configuration Tool with correct SQL Server"
        write-host "Getting SQL Server Name from file"
        $configFile = "C:\\setup\\bts\\ESBConfigurationTool.exe.config"
        $sqlName = [System.IO.File]::ReadAllText("c:\\setup\\bts\\DynamicServerName.txt")
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("@sqlserver", "$sqlName")
        [System.IO.File]::WriteAllText($configFile, $updatedContent)

        copy-item -path "C:\\setup\\bts\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config"
        [System.IO.File]::WriteAllText("c:\\setup\\bts\\_esbConfigured.lock", "complete")

    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_esbConfigured.lock")) '
end
log "#{cookbook_name}::BizTalk 2013 R2 TEST ESB Toolkit Configured"

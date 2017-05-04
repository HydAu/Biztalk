
directory 'c:\setup\bts\FinSuite\esbext' do
  action :create
  recursive true
end
log "#{cookbook_name}::Directory d:\\Log Created successfully"

cookbook_file 'c:\\setup\\bts\\Install_BizTalkApplications.ps1' do
  source 'Install_BizTalkApplications.ps1'
  action :create_if_missing
  # file name in in ur files dir
end
log "#{cookbook_name}::BizTalk InstallBizTalkApplications Silently Powershell script downloaded"

remote_file 'c:\setup\bts\FinSuite\name.ESB.Core-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.Core-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\name.ESB.OAGIS-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.OAGIS-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\name.ESB.GL-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.GL-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\name.ESB.Master-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.Master-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\name.ESB.ARBL-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.ARBL-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\name.ESB.APCM-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.APCM-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\name.ESB.FinUser-1.0.0.0.msi' do
  source node['BIZTALK']['name.ESB.FinUser-1.0.0.0.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\esbext\name.ESB.Extensions.Library.Setup.msi' do
  source node['BIZTALK']['name.ESB.Extensions.Library.Setup.msi']
  action :create_if_missing
end

remote_file 'c:\setup\bts\FinSuite\esbext\cab1.cab' do
  source node['BIZTALK']['name.ESB.Extensions.Library.cab1.cab']
  action :create_if_missing
end

log "#{cookbook_name}::Installing name.ESB.Core-1.0.0.0.msi"
package 'name.ESB.Core-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.Core-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.Core-1.0.0.0.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.OAGIS-1.0.0.0.msi"
package 'name.ESB.OAGIS-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.OAGIS-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.OAGIS-1.0.0.0.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.GL-1.0.0.0.msi"
package 'name.ESB.GL-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.GL-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.GL-1.0.0.0.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.ARBL-1.0.0.0.msi"
package 'name.ESB.ARBL-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.ARBL-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.ARBL-1.0.0.0.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.Master-1.0.0.0.msi"
package 'name.ESB.Master-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.Master-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.Master-1.0.0.0.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.APCM-1.0.0.0.msi"
package 'name.ESB.APCM-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.APCM-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.APCM-1.0.0.0.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.Extensions.library.setup.msi"
package 'name.ESB.Extensions.library.setup.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\esbext\name.ESB.Extensions.Library.Setup.msi'
end
log "#{cookbook_name}::name.ESB.Extensions.library.setup.msi Installed Successfully"

log "#{cookbook_name}::Installing name.ESB.FinUser-1.0.0.0.msi"
package 'name.ESB.FinUser-1.0.0.0.msi Installation' do
  action :install
  source 'c:\setup\bts\FinSuite\name.ESB.FinUser-1.0.0.0.msi'
end
log "#{cookbook_name}::name.ESB.FinUser-1.0.0.0.msi Installed Successfully"

powershell_script 'Register FinSuite Applications In BizTalk' do
  code <<-EOH

          write-host "Setting Execution policy for the current session"
          Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -force

          write-host "Registering Core v1.0.0.0"
          cd "C:\\Program Files (x86)\\name.ESB.Core\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.Core-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.Core\\1.0.0.0\\Deployment\\name.ESB.Core-1.0.0.0.msi"

         # .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.Core-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.Core\\1.0.0.0" -DeploymentFile name.ESB.Core.deployment.btdfproj -Environment DEV

          write-host "Registering OAGIS v1.0.0.0"
          cd "C:\\Program Files (x86)\\name.ESB.Oagis\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.Oagis-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.Oagis\\1.0.0.0\\Deployment\\name.ESB.Oagis-1.0.0.0.msi"

    #      .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.Oagis-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.Oagis\\1.0.0.0"  -DeploymentFile name.ESB.OAGIS.deployment.btdfproj -Environment DEV

          write-host "Registering GL v1.0.0.0"
         cd "C:\\Program Files (x86)\\name.ESB.GL\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.GL-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.GL\\1.0.0.0\\Deployment\\name.ESB.GL-1.0.0.0.msi"

     #     .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.GL-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.GL\\1.0.0.0" -DeploymentFile name.ESB.GL.deployment.btdfproj -Environment DEV


          write-host "Registering ARBL v1.0.0.0"
          cd "C:\\Program Files (x86)\\name.ESB.ARBL\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.ARBL-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.ARBL\\1.0.0.0\\Deployment\\name.ESB.ARBL-1.0.0.0.msi"

      #    .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.ARBL-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.ARBL\\1.0.0.0" -DeploymentFile name.ESB.ARBL.deployment.btdfproj -Environment DEV


          write-host "Registering Master v1.0.0.0"
         cd "C:\\Program Files (x86)\\name.ESB.Master\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.Master-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.Master\\1.0.0.0\\Deployment\\name.ESB.Master-1.0.0.0.msi"

      #    .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.Master-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.Master\\1.0.0.0" -DeploymentFile name.ESB.Master.deployment.btdfproj -Environment DEV



          write-host "Registering APCM v1.0.0.0"
         cd "C:\\Program Files (x86)\\name.ESB.APCM\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.APCM-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.APCM\\1.0.0.0\\Deployment\\name.ESB.APCM-1.0.0.0.msi"

       #   .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.APCM-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.APCM\\1.0.0.0" -DeploymentFile name.ESB.APCM.deployment.btdfproj -Environment DEV


          write-host "Registering FinUser v1.0.0.0"
         cd "C:\\Program Files (x86)\\name.ESB.FinUser\\1.0.0.0\\Deployment"
          copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
          copy-item -path "c:\\setup\\bts\\FinSuite\\name.ESB.FinUser-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\name.ESB.FinUser\\1.0.0.0\\Deployment\\name.ESB.FinUser-1.0.0.0.msi"

        #  .\\Install_BizTalkApplications.ps1 -MsiFile "name.ESB.FinUser-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\name.ESB.FinUser\\1.0.0.0" -DeploymentFile Deployment.btdfproj -Environment DEV


   [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefFinSuiteApps.lock", "complete")

    EOH
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefFinSuiteApps.lock")'
end
log "#{cookbook_name}::FinSuite Applications Registered"

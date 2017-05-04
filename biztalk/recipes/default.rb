
directory 'c:\Setup\Bts' do
  action :create
  recursive true
end
log "#{cookbook_name}::Directory c:\\Setup\\BTS Created successfully"

remote_file 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi' do
  action :create_if_missing
  source node['BIZTALK']['BTS_DeploymentFrameworkMsiUrl']
end
log "#{cookbook_name}::DeploymentFrameworkFor Biztalk Msi downloaded from Artifactory to C:\\setup\\bts\\DeploymentFrameworkForBizTalkV5_6.msi successfully"

remote_file 'c:\setup\bts\SqlXml4.msi' do
  source node['BIZTALK']['SQLXmlUrl']
  action :create_if_missing
end
log "#{cookbook_name}::SQL Xml version 4.0 msi from artifactory downloaded to C:\\setup\\bts\\SqlXml4.msi successfully"

remote_file 'c:\setup\bts\BTS.iso' do
  source node['BIZTALK']['BTS_ISOUrl']
  action :create_if_missing
end
log "#{cookbook_name}:: BizTalk Setup ISO File downloaded from Artifactory Server as C:\\setup\\bts\\BTS.iso successfully"

remote_file 'c:\setup\bts\BTSRedistW2k12EN64.cab' do
  source node['BIZTALK']['BTS_DependencyCabUrl']
  action :create_if_missing
end
log "#{cookbook_name}::BizTalk Dependency Cab File downloaded from Artifactory Server as C:\\setup\\bts\\BTSRedistW2k8EN64.cab successfully"

name_secret "#{node['DeploymentStage']}/#{node['AppName']}/#{node['Role']}/secret1" do
  destination 'secret1'
end

template 'c:\setup\bts\BizTalkLocalDevFeatures.xml' do
  source 'BizTalkFeaturesDevServer.erb'
  action :create_if_missing
  variables lazy {
    {
      BTS_SvcHostAccount: node.run_state['secret1']['BTS_SvcHostAccount'],
      BTS_SvcHostAccountPassword: node.run_state['secret1']['BTS_SvcHostAccountPassword'],
      BTS_SvcIsoHostAccount: node.run_state['secret1']['BTS_SvcIsoHostAccount'],
      BTS_SvcIsoHostAccountPassword: node.run_state['secret1']['BTS_SvcIsoHostAccountPassword'],
      BTS_InstallerAccount: node.run_state['secret1']['BTS_InstallerAccount'],
      BTS_InstallerAccountPassword: node.run_state['secret1']['BTS_InstallerAccountPassword'],
      BTS_LocalSvcHostAccount: node.run_state['secret1']['BTS_LocalSvcHostAccount'],
      BTS_LocalSvcHostAccountPassword: node.run_state['secret1']['BTS_LocalSvcHostAccountPassword'],
      BTS_LocalSvcIsoHostAccount: node.run_state['secret1']['BTS_LocalSvcIsoHostAccount'],
      BTS_LocalSvcIsoHostAccountPassword: node.run_state['secret1']['BTS_LocalSvcIsoHostAccountPassword'],
      BTS_InstallDirectory: node.run_state['secret1']['BTS_InstallDirectory'],
      BTS_ISOFile: node.run_state['secret1']['BTS_ISOFile'],
      BTS_ServerFeaturesFile: node.run_state['secret1']['BTS_ServerFeaturesFile'],
      BTS_BuildFeaturesFile: node.run_state['secret1']['BTS_BuildFeaturesFile'],
      BTS_LocalDevFeaturesFile: node.run_state['secret1']['BTS_LocalDevFeaturesFile'],
      VS_ISOFile: node.run_state['secret1']['VS_ISOFile'],
      SQL_ISOUrl: node.run_state['secret1']['SQL_ISOUrl'],
      VSAdminDeploymentFile: node.run_state['secret1']['VSAdminDeploymentFile'],
      BTS_DependencyCab: node.run_state['secret1']['BTS_DependencyCab'],
      BTS_DependencyCabUrl: node.run_state['secret1']['BTS_DependencyCabUrl'],
      BTS_LogFile: node.run_state['secret1']['BTS_LogFile'],
      BTS_ISOUrl: node.run_state['secret1']['BTS_ISOUrl'],
      BTS_FeaturesFileUrl: node.run_state['secret1']['BTS_FeaturesFileUrl'],
      BTS_DeploymentFrameworkMsiUrl: node.run_state['secret1']['BTS_DeploymentFrameworkMsiUrl'],
      VS2013_IsoUrl: node.run_state['secret1']['VS2013_IsoUrl'],
      SQLXmlUrl: node.run_state['secret1']['SQLXmlUrl'],
      SSO_Db_Name: node.run_state['secret1']['SSO_Db_Name'],
      BTS_Mgmt_Db_Name: node.run_state['secret1']['BTS_Mgmt_Db_Name'],
      BTS_MsgBox_Db_Name: node.run_state['secret1']['BTS_MsgBox_Db_Name'],
      BTS_Tracking_Db_Name: node.run_state['secret1']['BTS_Tracking_Db_Name'],
      BRE_Db_Name: node.run_state['secret1']['BRE_Db_Name'],
      BAM_StarSchema_Db_Name: node.run_state['secret1']['BAM_StarSchema_Db_Name'],
      BAM_Analysis_Db_Name: node.run_state['secret1']['BAM_Analysis_Db_Name'],
      BAM_Archive_Db_Name: node.run_state['secret1']['BAM_Archive_Db_Name'],
      BAM_PIT_Db_Name: node.run_state['secret1']['BAM_PIT_Db_Name'],
      BTS_SvcHostAccountDomain: node.run_state['secret1']['BTS_SvcHostAccountDomain'],
      BTS_SvcIsoHostAccountDomain: node.run_state['secret1']['BTS_SvcIsoHostAccountDomain'],
      BTS_InstallerAccountDomain: node.run_state['secret1']['BTS_InstallerAccountDomain'],
      SQL_ServerName: node.run_state['secret1']['SQL_ServerName'],
      SQL_LocalServerName: node.run_state['secret1']['SQL_LocalServerName'],
      SQL_ISO_FILE: node.run_state['secret1']['SQL_ISO_FILE'],
      BTS_LocalSvcHostAccountDomain: node.run_state['secret1']['BTS_LocalSvcHostAccountDomain'],
      BTS_LocalSvcIsoHostAccountDomain: node.run_state['secret1']['BTS_LocalSvcIsoHostAccountDomain'],
      ESB_Itinerary_DBName: node.run_state['secret1']['ESB_Itinerary_DBName'],
      ESB_Exception_DBName: node.run_state['secret1']['ESB_Exception_DBName'],
      VS_InstallLog: node.run_state['secret1']['VS_InstallLog'],
      VS_InstallPath: node.run_state['secret1']['VS_InstallPath'],
      BTS_PowerShellUrl: node.run_state['secret1']['BTS_PowerShellUrl'],
      BTS_ALLExceptions_SQLConnection: node.run_state['secret1']['BTS_ALLExceptions_SQLConnection'],
      SQL_XREF_Backup: node.run_state['secret1']['SQL_XREF_Backup'],
      SQL_DynamicInstanceName: node.run_state['secret1']['SQL_DynamicInstanceName']
    }
  }
end
log "#{cookbook_name}::BizTalk Local Dev Features File from template copied to C:\\setup\\bts\\BizTalkFeatures.xml successfully"

template 'c:\setup\bts\BizTalkServerFeatures.xml' do
  source 'BizTalkFeaturesServer.erb'
  action :create_if_missing
  variables lazy {
      {
        BTS_SvcHostAccount: node.run_state['secret1']['BTS_SvcHostAccount'],
        BTS_SvcHostAccountPassword: node.run_state['secret1']['BTS_SvcHostAccountPassword'],
        BTS_SSO_SvcHostAccount: node.run_state['secret1']['BTS_SSO_SvcHostAccount'],
        BTS_SSO_SvcHostAccountPassword: node.run_state['secret1']['BTS_SSO_SvcHostAccountPassword'],
        BTS_InstallerAccount: node.run_state['secret1']['BTS_InstallerAccount'],
        BTS_InstallerAccountPassword: node.run_state['secret1']['BTS_InstallerAccountPassword'],
        BTS_BRE_SvcHostAccount: node.run_state['secret1']['BTS_BRE_SvcHostAccount'],
        BTS_BRE_SvcHostAccountPassword: node.run_state['secret1']['BTS_BRE_SvcHostAccountPassword'],
        BTS_SvcHostIsoAccount: node.run_state['secret1']['BTS_SvcHostIsoAccount'],
        BTS_SvcHostIsoAccountPassword: node.run_state['secret1']['BTS_SvcHostIsoAccountPassword'],
        BTS_InstallDirectory: node.run_state['secret1']['BTS_InstallDirectory'],
        BTS_ISOFile: node.run_state['secret1']['BTS_ISOFile'],
        BTS_ServerFeaturesFile: node.run_state['secret1']['BTS_ServerFeaturesFile'],
        BTS_BuildFeaturesFile: node.run_state['secret1']['BTS_BuildFeaturesFile'],
        BTS_LocalDevFeaturesFile: node.run_state['secret1']['BTS_LocalDevFeaturesFile'],
        VS_ISOFile: node.run_state['secret1']['VS_ISOFile'],
        SQL_ISOUrl: node.run_state['secret1']['SQL_ISOUrl'],
        VSAdminDeploymentFile: node.run_state['secret1']['VSAdminDeploymentFile'],
        BTS_DependencyCab: node.run_state['secret1']['BTS_DependencyCab'],
        BTS_DependencyCabUrl: node.run_state['secret1']['BTS_DependencyCabUrl'],
        BTS_LogFile: node.run_state['secret1']['BTS_LogFile'],
        BTS_ISOUrl: node.run_state['secret1']['BTS_ISOUrl'],
        BTS_FeaturesFileUrl: node.run_state['secret1']['BTS_FeaturesFileUrl'],
        BTS_DeploymentFrameworkMsiUrl: node.run_state['secret1']['BTS_DeploymentFrameworkMsiUrl'],
        VS2013_IsoUrl: node.run_state['secret1']['VS2013_IsoUrl'],
        SQLXmlUrl: node.run_state['secret1']['SQLXmlUrl'],
        SSO_Db_Name: node.run_state['secret1']['SSO_Db_Name'],
        BTS_Mgmt_Db_Name: node.run_state['secret1']['BTS_Mgmt_Db_Name'],
        BTS_MsgBox_Db_Name: node.run_state['secret1']['BTS_MsgBox_Db_Name'],
        BTS_Tracking_Db_Name: node.run_state['secret1']['BTS_Tracking_Db_Name'],
        BRE_Db_Name: node.run_state['secret1']['BRE_Db_Name'],
        BAM_StarSchema_Db_Name: node.run_state['secret1']['BAM_StarSchema_Db_Name'],
        BAM_Analysis_Db_Name: node.run_state['secret1']['BAM_Analysis_Db_Name'],
        BAM_Archive_Db_Name: node.run_state['secret1']['BAM_Archive_Db_Name'],
        BAM_PIT_Db_Name: node.run_state['secret1']['BAM_PIT_Db_Name'],
        BTS_SvcHostAccountDomain: node.run_state['secret1']['BTS_SvcHostAccountDomain'],
        BTS_SvcIsoHostAccountDomain: node.run_state['secret1']['BTS_SvcIsoHostAccountDomain'],
        BTS_InstallerAccountDomain: node.run_state['secret1']['BTS_InstallerAccountDomain'],
        SQL_ServerName: node.run_state['secret1']['SQL_ServerName'],
        SQL_LocalServerName: node.run_state['secret1']['SQL_LocalServerName'],
        SQL_ISO_FILE: node.run_state['secret1']['SQL_ISO_FILE'],
        BTS_LocalSvcHostAccountDomain: node.run_state['secret1']['BTS_LocalSvcHostAccountDomain'],
        BTS_LocalSvcIsoHostAccountDomain: node.run_state['secret1']['BTS_LocalSvcIsoHostAccountDomain'],
        ESB_Itinerary_DBName: node.run_state['secret1']['ESB_Itinerary_DBName'],
        ESB_Exception_DBName: node.run_state['secret1']['ESB_Exception_DBName'],
        VS_InstallLog: node.run_state['secret1']['VS_InstallLog'],
        VS_InstallPath: node.run_state['secret1']['VS_InstallPath'],
        BTS_PowerShellUrl: node.run_state['secret1']['BTS_PowerShellUrl'],
        BTS_ALLExceptions_SQLConnection: node.run_state['secret1']['BTS_ALLExceptions_SQLConnection'],
        SQL_XREF_Backup: node.run_state['secret1']['SQL_XREF_Backup'],
        SQL_DynamicInstanceName: node.run_state['secret1']['SQL_DynamicInstanceName']
      }}
end

log "#{cookbook_name}::BizTalk Server Features File from template copied to C:\\setup\\bts\\BizTalkFeatures.xml successfully"

template 'c:\setup\bts\BizTalkBuildFeatures.xml' do
  source 'BizTalkFeaturesBuildServer.erb'
  action :create_if_missing
  variables lazy {
    {
      BTS_SvcHostAccount: node.run_state['secret1']['BTS_SvcHostAccount'],
      BTS_SvcHostAccountPassword: node.run_state['secret1']['BTS_SvcHostAccountPassword'],
      BTS_SvcIsoHostAccount: node.run_state['secret1']['BTS_SvcIsoHostAccount'],
      BTS_SvcIsoHostAccountPassword: node.run_state['secret1']['BTS_SvcIsoHostAccountPassword'],
      BTS_InstallerAccount: node.run_state['secret1']['BTS_InstallerAccount'],
      BTS_InstallerAccountPassword: node.run_state['secret1']['BTS_InstallerAccountPassword'],
      BTS_LocalSvcHostAccount: node.run_state['secret1']['BTS_LocalSvcHostAccount'],
      BTS_LocalSvcHostAccountPassword: node.run_state['secret1']['BTS_LocalSvcHostAccountPassword'],
      BTS_LocalSvcIsoHostAccount: node.run_state['secret1']['BTS_LocalSvcIsoHostAccount'],
      BTS_LocalSvcIsoHostAccountPassword: node.run_state['secret1']['BTS_LocalSvcIsoHostAccountPassword'],
      BTS_InstallDirectory: node.run_state['secret1']['BTS_InstallDirectory'],
      BTS_ISOFile: node.run_state['secret1']['BTS_ISOFile'],
      BTS_ServerFeaturesFile: node.run_state['secret1']['BTS_ServerFeaturesFile'],
      BTS_BuildFeaturesFile: node.run_state['secret1']['BTS_BuildFeaturesFile'],
      BTS_LocalDevFeaturesFile: node.run_state['secret1']['BTS_LocalDevFeaturesFile'],
      VS_ISOFile: node.run_state['secret1']['VS_ISOFile'],
      SQL_ISOUrl: node.run_state['secret1']['SQL_ISOUrl'],
      VSAdminDeploymentFile: node.run_state['secret1']['VSAdminDeploymentFile'],
      BTS_DependencyCab: node.run_state['secret1']['BTS_DependencyCab'],
      BTS_DependencyCabUrl: node.run_state['secret1']['BTS_DependencyCabUrl'],
      BTS_LogFile: node.run_state['secret1']['BTS_LogFile'],
      BTS_ISOUrl: node.run_state['secret1']['BTS_ISOUrl'],
      BTS_FeaturesFileUrl: node.run_state['secret1']['BTS_FeaturesFileUrl'],
      BTS_DeploymentFrameworkMsiUrl: node.run_state['secret1']['BTS_DeploymentFrameworkMsiUrl'],
      VS2013_IsoUrl: node.run_state['secret1']['VS2013_IsoUrl'],
      SQLXmlUrl: node.run_state['secret1']['SQLXmlUrl'],
      SSO_Db_Name: node.run_state['secret1']['SSO_Db_Name'],
      BTS_Mgmt_Db_Name: node.run_state['secret1']['BTS_Mgmt_Db_Name'],
      BTS_MsgBox_Db_Name: node.run_state['secret1']['BTS_MsgBox_Db_Name'],
      BTS_Tracking_Db_Name: node.run_state['secret1']['BTS_Tracking_Db_Name'],
      BRE_Db_Name: node.run_state['secret1']['BRE_Db_Name'],
      BAM_StarSchema_Db_Name: node.run_state['secret1']['BAM_StarSchema_Db_Name'],
      BAM_Analysis_Db_Name: node.run_state['secret1']['BAM_Analysis_Db_Name'],
      BAM_Archive_Db_Name: node.run_state['secret1']['BAM_Archive_Db_Name'],
      BAM_PIT_Db_Name: node.run_state['secret1']['BAM_PIT_Db_Name'],
      BTS_SvcHostAccountDomain: node.run_state['secret1']['BTS_SvcHostAccountDomain'],
      BTS_SvcIsoHostAccountDomain: node.run_state['secret1']['BTS_SvcIsoHostAccountDomain'],
      BTS_InstallerAccountDomain: node.run_state['secret1']['BTS_InstallerAccountDomain'],
      SQL_ServerName: node.run_state['secret1']['SQL_ServerName'],
      SQL_LocalServerName: node.run_state['secret1']['SQL_LocalServerName'],
      SQL_ISO_FILE: node.run_state['secret1']['SQL_ISO_FILE'],
      BTS_LocalSvcHostAccountDomain: node.run_state['secret1']['BTS_LocalSvcHostAccountDomain'],
      BTS_LocalSvcIsoHostAccountDomain: node.run_state['secret1']['BTS_LocalSvcIsoHostAccountDomain'],
      ESB_Itinerary_DBName: node.run_state['secret1']['ESB_Itinerary_DBName'],
      ESB_Exception_DBName: node.run_state['secret1']['ESB_Exception_DBName'],
      VS_InstallLog: node.run_state['secret1']['VS_InstallLog'],
      VS_InstallPath: node.run_state['secret1']['VS_InstallPath'],
      BTS_PowerShellUrl: node.run_state['secret1']['BTS_PowerShellUrl'],
      BTS_ALLExceptions_SQLConnection: node.run_state['secret1']['BTS_ALLExceptions_SQLConnection'],
      SQL_XREF_Backup: node.run_state['secret1']['SQL_XREF_Backup'],
      SQL_DynamicInstanceName: node.run_state['secret1']['SQL_DynamicInstanceName']
    }
  }
end
log "#{cookbook_name}::BizTalk Build Features File from template copied to C:\\setup\\bts\\BizTalkFeatures.xml successfully"

#  log "#{cookbook_name}::Tell Feature Installer to bypass the WSUS and go to WIndows Updates for Windows Features Sources"
#  registry_key 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing' do
#   values [{
#     name: 'RepairContentServerSource',
#     :type => :dword,
#     data: 2
#   }]
#   action :create_if_missing
#  end

include_recipe 'name_iis_core::default'
log "#{cookbook_name}::Enabled IIS"

include_recipe "#{cookbook_name}::Enable_HttpRedirect"
log "#{cookbook_name}::Enabled HttpRedirect"

include_recipe "#{cookbook_name}::Enable_Web_Security"
log "#{cookbook_name}::Enabled Web Security"

include_recipe "#{cookbook_name}::Enable_Health_Diagnostics"
log "#{cookbook_name}::Enabled Health and Diagnostics"

include_recipe "#{cookbook_name}::Enable_WindowsIdentityFoundation"
log "#{cookbook_name}::Enabled Windows Identity Foundation"

include_recipe "#{cookbook_name}::Disable_IPv6"
log "#{cookbook_name}::DisableIPv6 successfully"

include_recipe "#{cookbook_name}::Disable_IE_Enhanced_Security"
log "#{cookbook_name}::Disabled IE Enhanced Security Successfully"

include_recipe "#{cookbook_name}::Disable_UAC"
log "#{cookbook_name}::Disabled UAC successfully"

include_recipe "#{cookbook_name}::Disable_FireWall"
log "#{cookbook_name}::Disabled Firewall Successfully"

include_recipe "#{cookbook_name}::ConfigureApplicationEventLog"
log "#{cookbook_name}::Configured Application Event Log Successfully"

include_recipe "#{cookbook_name}::Enable_ApplicationDevelopment"
log "#{cookbook_name}::Enabled Application Development features"

reboot 'Enable Application Dev Features' do
  action :nothing
end

include_recipe "#{cookbook_name}::Enable_NetFramework45_Features"
log "#{cookbook_name}::Enabled .Net 4.5 framework features"

include_recipe "#{cookbook_name}::Enable_ASPNet45"
log "#{cookbook_name}::Enabled ASP.Net 4.5 framework"

include_recipe "#{cookbook_name}::Enable_NetFramework20"
log "#{cookbook_name}::Enabled .Net Framework 2.0 and 3.5"

include_recipe "#{cookbook_name}::Enable_IIS6_Mgmt_Compatibility"
log "#{cookbook_name}::Enabled IIS 6.0 Management Compatibility"

include_recipe "#{cookbook_name}::Enable_FTP"
log "#{cookbook_name}::Enabled IIS FTP"

include_recipe "#{cookbook_name}::Enable_Windows_Process_Activation_Service"
log "#{cookbook_name}::Enabled Windows Process Activation Service successfully"

include_recipe "#{cookbook_name}::Enable_TelnetClient"
log "#{cookbook_name}::Enabled Telnet Client successfully"

include_recipe "#{cookbook_name}::Enable_MessageQueuing"
log "#{cookbook_name}::Enabled Message Queuing successfully"

windows_package 'SQL Xml v4.0' do
  action :install
  source 'c:\setup\bts\SQLXml4.msi'
end
log "#{cookbook_name}::SQL Xml version 4.0 was installed"

cookbook_file 'c:\\setup\\bts\\BizTalkFactoryPowershell.msi' do
  source 'BizTalkFactory.PowerShell.Extensions.Setup - v1.4.0.1.msi'
  action :create_if_missing
end
log "#{cookbook_name}::BizTalk BizTalk Factory Powershell Extensions downloaded"

package 'BizTalk Factory Powershell Extensions Installation' do
  action :install
  source 'c:\setup\bts\BizTalkFactoryPowerShell.msi'
end

case node['BIZTALK']['DefaultConfig']
when 'LocalDev'
  include_recipe "#{cookbook_name}::Install_BizTalk_LocalDevServer"
when 'Server'
  include_recipe "#{cookbook_name}::Install_BizTalk_LocalDevServer"
when 'Test'
  include_recipe "#{cookbook_name}::Install_BizTalk_TestServer"
when 'Build'
  include_recipe "#{cookbook_name}::Install_BizTalk_LocalDevServer"
end

package 'DeploymentFramework' do
  action :install
  source 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi'
end

case node['BIZTALK']['DefaultConfig']
when 'LocalDev'
  include_recipe "#{cookbook_name}::configure_Local_BizTalk"
  include_recipe "#{cookbook_name}::Configure_Local_FinSuiteHosts"
  include_recipe "#{cookbook_name}::Install_Local_FinSuiteApplications"
  include_recipe "#{cookbook_name}::Restore_Local_XREF_Database"
  # when 'Test'
  #  include_recipe "#{cookbook_name}::configure_Test_BizTalk"
  #  include_recipe "#{cookbook_name}::Configure_FinSuiteHosts"
  #  include_recipe "#{cookbook_name}::Install_FinSuiteApplications"
end

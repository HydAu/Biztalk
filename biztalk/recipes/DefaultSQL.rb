
directory 'c:\setup\sql' do
  action :create
  recursive true
end

# include_recipe 'name_iis_core::default'
# log "#{cookbook_name}::Enabled IIS"

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

include_recipe "#{cookbook_name}::Enable_NetFramework45_Features"
log "#{cookbook_name}::Enabled .Net 4.5 framework features"

include_recipe "#{cookbook_name}::Enable_NetFramework20"
log "#{cookbook_name}::Enabled .Net Framework 2.0 and 3.5"

include_recipe "#{cookbook_name}::InstallSql_AllFeatures"
log "#{cookbook_name}::Installed SQL"

include_recipe "#{cookbook_name}::JoinDomain"
log "#{cookbook_name}::Joined Domain"

include_recipe "#{cookbook_name}::enableNetworkDTC"
log "#{cookbook_name}::enabling Network DTC"

include_recipe "#{cookbook_name}::RestoreXREF_Database"
log "#{cookbook_name}::Restored XREF Databases"

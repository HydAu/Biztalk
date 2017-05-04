powershell_script 'Enable IIS FTP Service' do
  code 'Add-WindowsFeature Web-FTP-Server'
  guard_interpreter :powershell_script
  not_if '((get-windowsfeature) | where { $_.Name -eq "Web-FTP-Server" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS FTP Enabled"

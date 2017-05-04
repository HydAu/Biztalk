

reboot 'now' do
  action :nothing
  reason 'Needs SQLPS installed properly'
  delay_mins 5
end

directory 'c:\Setup\SQL' do
  recursive true
  action :create
end

directory 'D:\Program Files (x86)\Microsoft SQL Server\DReplayClient\WorkingDir' do
  recursive true
  action :create
end

directory 'D:\Program Files (x86)\Microsoft SQL Server\DReplayClient\ResultDir' do
  recursive true
  action :create
end

remote_file 'c:\setup\sql\en_sql_server_2014_developer_edition_with_service_pack_2_x64_dvd_8967821.iso' do
  source node['BIZTALK']['SQL_ISOUrl']
  action :create_if_missing
end
log "#{cookbook_name}::SQL Iso downloaded from Artifactory to c:\\setup\\sql successfully"

template 'c:\setup\sql\Configuration.ini' do
  source 'SQLConfig.erb'
  action :create_if_missing
end
log "#{cookbook_name}::SQL Conifguration.ini  C:\\setup\\sql\\Configuration.ini successfully"

# we need to launch the actual install using a different credential and account
# basically a RunAs ...

cookbook_file 'c:\\setup\\sql\\InstallSQL.ps1' do
  source 'InstallSQL.ps1'
  action :create_if_missing
end
log "#{cookbook_name}::InstallSQL.ps1 Silently Powershell script downloaded"

powershell_script 'Install SQL' do
  code <<-EOH

  $sqlIsoFile = "#{node.default['BIZTALK']['SQL_ISO_FILE']}"
  $sqlMountResult = (Mount-DiskImage $sqlIsoFile -PassThru)
  $sqlDriveLetter = ($sqlMountResult | Get-Volume).Driveletter
  $sqlDrive = $sqlDriveLetter + ":"
  cd $sqlDrive

  start-Process -filePath ".\\setup.exe" -argumentList "/q /ACTION=Install /UpdateEnabled=false /ConfigurationFile=c:\\setup\\SQL\\configuration.ini /IACCEPTSQLSERVERLICENSETERMS=true" -wait
  dismount-diskimage $sqlIsoFile

  EOH
  guard_interpreter :powershell_script
  not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
  notifies :reboot_now, 'reboot[now]', :immediately
  not_if '[System.IO.File]::Exists("D:\\Program Files\\Microsoft SQL Server\\MSSQL12.MSSQLSERVER\\MSSQL\\Binn\\sqlservr.exe")'
end
log "#{cookbook_name}::Installed SQL 2014 Successfully"

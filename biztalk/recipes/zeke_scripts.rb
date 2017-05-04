
cookbook_file "#{Chef::Config[:file_cache_path]}\\Zeke.zip" do
  source 'Zeke.zip'
end

powershell_script 'unzip a file' do
  code <<-EOH
  Expand-Archive -Path "#{Chef::Config[:file_cache_path]}\\Zeke.zip" -DestinationPath "#{Chef::Config[:file_cache_path]}\\Zeke"
  EOH
end

directory 'D:\\pprog\\name\\Batch' do
  recursive true
  action :create
end

powershell_script 'Move-Item' do
  code <<-EOH
  Move-Item -Path "#{Chef::Config[:file_cache_path]}\\Zeke\\Zeke\\TriggerESBMessage.bat" -Destination "D:\\pprog\\name\\Batch\\TriggerESBMessage.bat"
  Move-Item -Path "#{Chef::Config[:file_cache_path]}\\Zeke\\Zeke\\StatusVerification.ps1" -Destination "D:\\pprog\\name\\Batch\\StatusVerification.ps1"
  EOH
end

# Move-Item -Path "#{Chef::Config[:file_cache_path]}\\name-finsuite\\Batch Jobs\\Zeke\\TriggerESBMessage.bat" -Destination "D:\\pprog\\name\\Batch\\TriggerESBMessage.bat"

# Copy-Item -Path "#{Chef::Config[:file_cache_path]}\\Zeke\\Zeke\\TriggerFiles" -Destination "\\alvjmfwvom001as\\NAS_Host\\name.ESB.Message\\Zeke\\TriggerFiles"
# Remove-Item "#{Chef::Config[:file_cache_path]}\\Zeke\\Zeke\\TriggerFiles"

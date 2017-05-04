
# template for machine.config file
template "#{Chef::Config[:file_cache_path]}\\machine_config.ps1" do
  source 'machine_config_file.ps1.erb'
  variables(
    config_file: node['BIZTALK']['machine_entries']
  )
end

powershell_script 'run script' do
  # cwd "#{Chef::Config[:file_cache_path]}"
  code "#{Chef::Config[:file_cache_path]}\\machine_config.ps1 -configFile #{node['BIZTALK']['machine_entries']}"
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefMachineConfig.lock"))'
end

template "#{Chef::Config[:file_cache_path]}\\machine_config_v4.ps1" do
  source 'machine_config_file.ps1.erb'
  variables(
    config_file: node['BIZTALK']['machine64_entries']
  )
end

powershell_script 'run script' do
  # cwd "#{Chef::Config[:file_cache_path]}"
  code "#{Chef::Config[:file_cache_path]}\\machine_config_v4.ps1 -configFile #{node['BIZTALK']['machine64_entries']}"
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chef_v4_MachineConfig.lock"))'
end

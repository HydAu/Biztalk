
case node['BIZTALK']['environment_name']
when 'stage'

  template "#{Chef::Config[:file_cache_path]}\\config_append_stage.ps1" do
    source 'config_append_stage.ps1.erb'
    variables(
      config_file: node['BIZTALK']['entries'] # .erb
    )
  end
  template "#{Chef::Config[:file_cache_path]}\\config_append_stage64.ps1" do
    source 'config_append_stage64.ps1.erb'
    variables(
      config_file: node['BIZTALK']['entries_64']
    )
  end

  powershell_script 'run script' do
    # cwd "#{Chef::Config[:file_cache_path]}"
    code "#{Chef::Config[:file_cache_path]}\\config_append_stage.ps1"
    guard_interpreter :powershell_script
  end

  powershell_script 'run scripts' do
    # cwd "#{Chef::Config[:file_cache_path]}"
    code "#{Chef::Config[:file_cache_path]}\\config_append_stage64.ps1"
    guard_interpreter :powershell_script
  end

when 'production'

  template "#{Chef::Config[:file_cache_path]}\\config_append_prod.ps1" do
    source 'config_append_prod.ps1.erb'
    variables(
      config_file: node['BIZTALK']['entries']
    )
  end

  template "#{Chef::Config[:file_cache_path]}\\config_append_prod64.ps1" do
    source 'config_append_prod64.ps1.erb'
    variables(
      config_file: node['BIZTALK']['entries_64']
    )
  end
end

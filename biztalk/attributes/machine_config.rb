default['BIZTALK']['machine_source_dir'] = 'C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\CONFIG'

default['BIZTALK']['machineconfig_filename'] = 'machine_config_file.ps1.erb'

default['BIZTALK']['machine_entries'] = "#{node['BIZTALK']['machine_source_dir']}\\machine.config"

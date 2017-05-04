default['BIZTALK']['machinev4_source_dir'] = 'C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\CONFIG'

default['BIZTALK']['machineconfigv4_filename'] = 'machine_config_file.ps1.erb'

default['BIZTALK']['machine64_entries'] = "#{node['BIZTALK']['machinev4_source_dir']}\\machine.config"

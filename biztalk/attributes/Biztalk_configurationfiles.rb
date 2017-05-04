
default['BIZTALK']['biztalk_source_dir'] = 'C:\\Program Files (x86)\\Microsoft BizTalk Server 2013 R2'

default['BIZTALK']['environment_name'] = 'stage'
default['BIZTALK']['stage_filename'] = 'config_append_stage.ps1 '
default['BIZTALK']['stage64_filename'] = 'config_append_stage64.ps1 '
default['BIZTALK']['prod_filename'] = 'config_append_prod.ps1 '
default['BIZTALK']['prod64_filename'] = 'config_append_prod64.ps1 '

default['BIZTALK']['entries'] = "#{node['BIZTALK']['biztalk_source_dir']}\\BTSNTSvc.exe.config"

default['BIZTALK']['entries_64'] = "#{node['BIZTALK']['biztalk_source_dir']}\\BTSNTSvc64.exe.config"

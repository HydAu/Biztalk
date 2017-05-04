default['BIZTALK']['esb_source_dir'] = 'C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit'

default['BIZTALK']['esb_filename'] = 'esbconfig_append.ps1.erb'

default['BIZTALK']['esb_entries'] = "#{node['BIZTALK']['esb_source_dir']}\\esb.config"

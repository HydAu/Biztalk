default['BIZTALK']['environment_name'] = 'stage' # set to default please override in roles or environments

case node['BIZTALK']['environment_name']
when 'stage'
  default['BIZTALK']['tns_template_name'] = 'stage_file.erb'
when 'production'
  default['BIZTALK']['tns_template_prod_name'] = 'production_file.erb'
end

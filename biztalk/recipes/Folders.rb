
dir_location = %w(D:\logs\name_FSP_LOG C:\Windows\SysWOW64\config\systemprofile\Desktop C:\Windows\System32\config\systemprofile\Desktop)

dir_location.each do |dir|
  directory dir
end

directory 'C:\Windows\System32\config\systemprofile\Desktop' do
  action :create
end

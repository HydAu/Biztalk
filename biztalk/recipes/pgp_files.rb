remote_file 'C:\Users\BizTalk_svc_Host\AppData\Roaming\gnupg' do
  source 'C:\Users\btinstallname\AppData\Roaming\gnupg '
end

batch 'ps script' do
  cwd 'location specified too'
  code <<-EOH
    paste the script
    EOH
end

file 'C:\\Users\\BizTalk_svc_Host\\AppData\\Roaming\\gnupg' do
  content '::File.open("C:\\Users\\btinstallname\\AppData\\Roaming\").read'
  action :create
end

# "/etc/init.d/someService" - target file,
# "/home/someService" - source file

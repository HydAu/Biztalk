
cookbook_file "#{Chef::Config[:file_cache_path]}\\setup.exe" do
  source 'gpg4win-2.3.3.exe' # file name in in ur files dir
end

template 'Chef::Config[:file_cache_path]\\gpg4win.ini' do
  source 'gpg4win.ini.erb'
end

template_path = 'Chef::Config[:file_cache_path]\\gpg4win.ini'

windows_package 'gnuPG installer' do
  source 'Chef::Config[:file_cache_path]\\setup.exe'
  options "/S /C=#{template_path}"
end

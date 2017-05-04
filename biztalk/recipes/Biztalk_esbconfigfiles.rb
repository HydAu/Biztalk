
# template for esb config file
template 'c:\setup\bts\esbconfig.config' do
  source 'esbconfig.erb'
  action :create_if_missing
end

powershell_script 'run esb script' do
  code
  code <<-EOH

       $configFile = "c:\\setup\\bts\\esbconfig.config"

       $sqlName = $env:COMPUTERNAME
       if ([System.IO.File]::exists("c:\\setup\\sql\\DynamicServerName.txt"))
       {
        $sqlName = [System.IO.File]::ReadAllText("c:\\setup\\sql\\DynamicServerName.txt")
       }

        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("@sqlserver", "$sqlName")
        [System.IO.File]::WriteAllText($configFile, $updatedContent)
        Copy-Item -path $configFile  -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\esb.config" -force

   EOH
  guard_interpreter :powershell_script
end

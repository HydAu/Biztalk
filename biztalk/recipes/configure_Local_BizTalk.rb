
reboot 'now' do
  action :nothing
  reason 'Needs Admin account to be inside of SSO Administrator Group'
  delay_mins 5
end

powershell_script 'Configure Local BizTalk Groups' do
  code <<-EOH
        $computer = $env:COMPUTERNAME
        $ADSI = [ADSI]("WinNT://$computer")

       try { $btsAppUsers = $ADSI.psbase.children.find('BizTalk Application Users', 'Group') }
       catch { $btsAppUsers = $null }

        if($btsAppUsers -eq $null)
        {
          $btsAppUsers = $ADSI.Create('Group', 'BizTalk Application Users')
          $btsAppUsers.SetInfo()
        }

      try { $btsIsoUsers = $ADSI.psbase.children.find('BizTalk Isolated Host Users', 'Group') }
       catch { $btsIsoUsers = $null }

        if($btsIsoUsers -eq $null)
        {
          $btsIsoUsers = $ADSI.Create('Group', 'BizTalk Isolated Host Users')
          $btsIsoUsers.SetInfo()
        }

      try { $btsServerAdmins = $ADSI.psbase.children.find('BizTalk Server Administrators', 'Group') }
       catch { $btsServerAdmins = $null }

        if($btsServerAdmins -eq $null)
        {
          $btsServerAdmins = $ADSI.Create('Group', 'BizTalk Server Administrators')
          $btsServerAdmins.SetInfo()
        }

      try { $btsServerB2BOps = $ADSI.psbase.children.find('BizTalk Server B2B Operators', 'Group') }
       catch { $btsServerB2BOps = $null }

        if($btsServerB2BOps -eq $null)
        {
          $btsServerB2BOps = $ADSI.Create('Group', 'BizTalk Server B2B Operators')
          $btsServerB2BOps.SetInfo()
        }

      try { $btsServerOps = $ADSI.psbase.children.find('BizTalk Server Operators', 'Group') }
       catch { $btsServerOps = $null }

        if($btsServerOps -eq $null)
        {
          $btsServerOps = $ADSI.Create('Group', 'BizTalk Server Operators')
          $btsServerOps.SetInfo()
        }

      try { $ssoAdmins = $ADSI.psbase.children.find('SSO Administrators', 'Group') }
       catch { $ssoAdmins = $null }

        if($ssoAdmins -eq $null)
        {
          $ssoAdmins = $ADSI.Create('Group', 'SSO Administrators')
          $ssoAdmins.SetInfo()
        }

        try { $ssoAffAdmins = $ADSI.psbase.children.find('SSO Affiliate Administrators', 'Group') }
       catch { $ssoAffAdmins = $null }

        if($ssoAffAdmins -eq $null)
        {
          $ssoAffAdmins = $ADSI.Create('Group', 'SSO Affiliate Administrators')
          $ssoAffAdmins.SetInfo()
        }

        NET LOCALGROUP "SSO Administrators" $env:USERNAME /ADD
        NET LOCALGROUP "BizTalk Server Administrators" $env:USERNAME /ADD

        $userName = "#{node['BIZTALK']['BTS_LocalSvcHostAccount']}"
        $userPassword = "#{node['BIZTALK']['BTS_LocalSvcHostAccountPassword']}"
        $isoUserName = "#{node['BIZTALK']['BTS_LocalSvcIsoHostAccount']}"
        $isoUserPassword = "#{node['BIZTALK']['BTS_LocalSvcIsoHostAccountPassword']}"

        write-host "Using : $userName  as Service Host Account to configure BizTalk"

        NET USER $userName $userPassword /ADD
        NET LOCALGROUP "BizTalk Application Users" $userName /ADD
        NET LOCALGROUP "SSO Administrators" $userName /ADD

        NET USER $isoUserName $isoUserPassword /ADD
        NET LOCALGROUP "BizTalk Isolated Host Users" $isoUserName /ADD

        write-host "Added  $userName to BTS Applications Users group "

        [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefBTSUsers.lock", "complete")

    EOH

  notifies :reboot_now, 'reboot[now]', :immediately
  guard_interpreter :powershell_script
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefBTSUsers.lock"))'
end
log "#{cookbook_name}::BizTalk Local Groups Configured"

powershell_script 'Configure Local BizTalk Instance' do
  code <<-EOH

        write-host "Getting SQL Server Name from file"
        $sqlName = $env:COMPUTERNAME
         $configFile = "#{node['BIZTALK']['BTS_LocalDevFeaturesFile']}"
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: " + $sqlName + " in features File"
        $_Content = $featuresFileContent.Replace("<Server>.</Server>", "<Server>$sqlName</Server>")
        $updatedContent = $_Content.Replace("<Domain>.</Domain>", "<Domain></Domain>")
        [System.IO.File]::WriteAllText("c:\\setup\\bts\\BizTalkFeatures.xml", $updatedContent)

        cd "C:\\Program Files (x86)\\Microsoft BizTalk Server 2013 R2"
        $argList = "/s " + $configFile + " /l c:\\setup\\bts\\configuration.log /noprogressbar"
        start-Process -filePath ".\\configuration.exe" -argumentList "/s c:\\setup\\bts\\BizTalkFeatures.xml /l c:\\setup\\bts\\configuration.log /noprogressbar" -wait

        [System.IO.File]::WriteAllText("c:\\setup\\bts\\_btsConfigured.lock", "complete")

    EOH
  guard_interpreter :powershell_script
  # not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
  not_if '( ( (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName -neq $null  ) -and ([System.IO.File]::exists("c:\\setup\\bts\\_btsConfigured.lock")) )'
end
log "#{cookbook_name}::BizTalk 2013 R2 Configured"

template 'c:\setup\bts\ESBConfigurationTool.exe.config' do
  source 'local.esbconfigurationtool.exe.config.erb'
  action :create_if_missing
end

powershell_script 'Configure BizTalk ESB Toolkit' do
  code <<-EOH

       # start-Process -filePath "C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\Common7\\IDE\\VSIXInstaller.exe" -argumentList """C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Tools\\Itinerary Designer\\Microsoft.Practices.Services.Itinerary.DslPackage.vsix"" /q /s:Ultimate /v:12.0" -wait

        move-item -path "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config.old" -force

        write-host "Updating ESB Configuration Tool with correct SQL Server"
        write-host "Getting SQL Server Name from file"
        $configFile = "C:\\setup\\bts\\ESBConfigurationTool.exe.config"
        $sqlName = $env:COMPUTERNAME
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("@sqlserver", "$sqlName")
        [System.IO.File]::WriteAllText($configFile, $updatedContent)

        copy-item -path "C:\\setup\\bts\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config" -force

        [System.IO.File]::WriteAllText("c:\\setup\\bts\\_esbConfigured.lock", "complete")

    EOH
  guard_interpreter :powershell_script
  # not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
  not_if '([System.IO.File]::exists("c:\\setup\\bts\\_esbConfigured.lock")) '
end
log "#{cookbook_name}::BizTalk 2013 R2 ESB Toolkit Configured"

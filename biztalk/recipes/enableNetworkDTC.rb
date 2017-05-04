
log "#{cookbook_name}::Checking Network DTC Security"
powershell_script 'Enable Network DTC Security Settings' do
  code <<-EOH

Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'NetworkDtcAccess' -Value '1'
Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'NetworkDtcAccessOutbound' -Value '1'
Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'NetworkDtcAccessInbound' -Value '1'
Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'NetworkDtcAccessTransactions' -Value '1'
Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'NetworkDtcAccessClients' -Value '1'
Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'XaTransactions' -Value '1'
Set-ItemProperty -Path "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security" -Name 'LuTransactions' -Value '1'

    EOH
  guard_interpreter :powershell_script
  not_if '(Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\MSDTC\\Security").NetworkDtcAccess -eq 1'
end
log "#{cookbook_name}::Network DTC Security Enabled"

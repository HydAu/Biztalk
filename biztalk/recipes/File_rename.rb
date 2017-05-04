
powershell_script 'Rename' do
  code <<-EOH
  Move-Item -Path "C:\\Windows\\Microsoft.NET\\assembly\\GAC_MSIL\\Microsoft.Practices.ESB.Filters.XPath\\v4.0_2.1.0.0__31bf3856ad364e35\\Microsoft.Practices.ESB.Filters.XPath.dlll" -Destination "C:\\Windows\\Microsoft.NET\\assembly\\GAC_MSIL\\Microsoft.Practices.ESB.Filters.XPath\\v4.0_2.1.0.0__31bf3856ad364e35\\Microsoft.Practices.ESB.Filters.XPath.dll"
  EOH
end

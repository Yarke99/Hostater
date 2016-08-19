<#
    FileName: Update-Hosts
    Author: Yarke
    QQCode: 649306855
    Create: 2016.06.03
    Update: 2016.08.20
#>
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){ 
    [console]::BackgroundColor = "DarkGreen"
    [console]::WindowHeight = 15
    [console]::WindowWidth = 56
    $Host.UI.RawUI.WindowTitle = "管理员: Windows Hosts File Editor" # $myInvocation.MyCommand.Name
} Else { 
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = $myInvocation.MyCommand.Definition
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null
    Exit
}

Push-Location $(Split-Path $Script:MyInvocation.MyCommand.Path)
[string] $hostsFile = Join-Path -Path $env:WINDIR -ChildPath "\System32\drivers\etc\hosts"

Function About(){
    Get-Content About.txt | Write-Host
}
Function Reset(){
    Write-Host 重置Hosts
    If (Test-Path "hosts_windows.txt"){
        Get-Content hosts_windows.txt | Set-Content $HostsFile
        ipconfig /flushdns | Out-Null
    } Else {
        Write-Host "hosts_windows.txt文件未找到。"
    }
    Write-Host 操作完成
}
Function AppendUser(){
    Write-Host 添加个人Hosts
    If (Test-Path "hosts_user.txt"){
        Get-Content hosts_user.txt | Add-Content $HostsFile
        ipconfig /flushdns | Out-Null
    } Else {
        Write-Host "hosts_user.txt文件未找到。"
    }
    Write-Host 操作完成
}
Function AppendWebsite(){
    Write-Host 添加翻墙
    Invoke-WebRequest "https://raw.githubusercontent.com/fengixng/google-hosts/master/dnsmasq.hosts" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content $HostsFile # Youtube完美观看
    Invoke-WebRequest "https://raw.githubusercontent.com/racaljk/hosts/master/hosts" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content $HostsFile
    Invoke-WebRequest "https://raw.githubusercontent.com/fengixng/google-hosts/master/hosts" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content $HostsFile # 风行个人 
    Invoke-WebRequest "https://raw.githubusercontent.com/linuxcer/hosts/master/hosts" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content $HostsFile
    #Invoke-WebRequest "https://raw.githubusercontent.com/linuxcer/hosts/master/hosts-a" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content HostsFile.txt # 备用
    #Invoke-WebRequest "https://raw.githubusercontent.com/linuxcer/hosts/master/hosts-b" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content HostsFile.txt # 备用
    #https://raw.githubusercontent.com/linuxcer/hosts/master/hosts-a
    
    Write-Host  添加广告屏蔽
    Invoke-WebRequest "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content $HostsFile
    Invoke-WebRequest "https://raw.githubusercontent.com/vokins/yhosts/master/hosts" | ForEach-Object{ $_ -replace "`r`n|`r|`n","`r`n"} | Add-Content $HostsFile
    ipconfig /flushdns | Out-Null
    Write-Host 操作完成
}
Function Update(){
    Reset
    AppendUser
    AppendWebsite
}
Function Edit(){
    Start-Process -FilePath "Notepad.exe" -ArgumentList $hostsFile -Wait
}

Do{
    Clear-Host
    Get-Content Menu.txt | Write-Host
    $selection = Read-Host "请输入菜单编号"
    Clear-Host
    switch ($selection)
    {
        {$_ -eq 0} {Exit}
        {$_ -eq 1} {Update; Break}
        {$_ -eq 2} {Reset; Break}
        {$_ -eq 3} {AppendUser; Break}
        {$_ -eq 4} {AppendWebsite; Break}
        {$_ -eq 5} {Edit; Break}
        Default    {About}
    }
    Write-Host 按任意键返回菜单...
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}Until ($input -eq '0')

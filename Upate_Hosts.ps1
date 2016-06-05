<#
    FileName: Update-Hosts
    Author: Yarke
    QQCode: 649306855
    Create: 2016.06.03
    Update: 2016.06.05
#>
Push-Location $(Split-Path $Script:MyInvocation.MyCommand.Path)
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){ 
    $Host.UI.RawUI.WindowTitle = "管理员: " + $myInvocation.MyCommand.Name
} Else { 
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = $myInvocation.MyCommand.Definition
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null
    Exit
} 
[string] $hostsFile = $env:WINDIR + "\System32\drivers\etc\hosts"
If (Test-Path $hostsFile){
    Get-Content hosts_windows.txt  | Set-Content $HostsFile # Windows原始文件
    Get-Content hosts_personal.txt | Set-Content $HostsFile # 个人配置
    Get-Content hosts_zjky.txt     | Add-Content $HostsFile # 紫金矿业
    Invoke-WebRequest "https://raw.githubusercontent.com/racaljk/hosts/master/hosts" | ForEach-Object{ $_ -replace "`n","`r`n"} | Add-Content $HostsFile # 屏蔽广告
    Invoke-WebRequest "https://raw.githubusercontent.com/vokins/yhosts/master/hosts" | ForEach-Object{ $_ -replace "`n","`r`n"} | Add-Content $HostsFile # 翻墙
} Else {
    Write-Host "Hosts文件未找到。"
}
Pause
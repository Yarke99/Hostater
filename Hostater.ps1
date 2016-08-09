<#
    FileName: Update-Hosts
    Author: Yarke
    QQCode: 649306855
    Create: 2016.06.03
    Update: 2016.07.01
#>
If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){ 
    [console]::BackgroundColor = "DarkGreen"
    [console]::WindowHeight = 15
    [console]::WindowWidth = 56
    $Host.UI.RawUI.WindowTitle = "����Ա: Windows Hosts File Editor" # $myInvocation.MyCommand.Name
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
    If (Test-Path "hosts_windows.txt"){
        Get-Content hosts_windows.txt | Set-Content $HostsFile
        ipconfig /flushdns | Out-Null
    } Else {
        Write-Host "hosts_windows.txt�ļ�δ�ҵ���"
    }
}
Function AppendZijin(){
    If (Test-Path "hosts_zjky.txt"){
        Get-Content hosts_zjky.txt | Add-Content $HostsFile
        ipconfig /flushdns | Out-Null
    } Else {
        Write-Host "hosts_zjky.txt�ļ�δ�ҵ���"
    }
}
Function AppendUser(){
    If (Test-Path "hosts_user.txt"){
        Get-Content hosts_user.txt | Add-Content $HostsFile
        ipconfig /flushdns | Out-Null
    } Else {
        Write-Host "hosts_user.txt�ļ�δ�ҵ���"
    }
}
Function AppendWebsite(){
    # ���ι��
    Invoke-WebRequest "https://raw.githubusercontent.com/racaljk/hosts/master/hosts" | ForEach-Object{ $_ -replace "`n","`r`n"} | Add-Content $HostsFile 
    Invoke-WebRequest "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | ForEach-Object{ $_ -replace "`n","`r`n"} | Add-Content $HostsFile

    # ��ǽ
    Invoke-WebRequest "https://raw.githubusercontent.com/vokins/yhosts/master/hosts" | ForEach-Object{ $_ -replace "`n","`r`n"} | Add-Content $HostsFile
    Invoke-WebRequest "https://raw.githubusercontent.com/cnAnonymous/hosts/master/hosts" | ForEach-Object{ $_ -replace "`n","`r`n"} | Add-Content $HostsFile
    ipconfig /flushdns | Out-Null
}
Function Update(){
    Reset
    AppendZijin
    AppendUser
    AppendWebsite
}
Function Edit(){
    Start-Process -FilePath "Notepad.exe" -ArgumentList $hostsFile -Wait
}

Do{
    Clear-Host
    Get-Content Menu.txt | Write-Host
    $selection = Read-Host "������˵����"
    Clear-Host
    switch ($selection)
    {
        {$_ -eq 0} {Exit}
        {$_ -eq 1} {Update; Break}
        {$_ -eq 2} {Reset; Break}
        {$_ -eq 3} {AppendZijin; Break}
        {$_ -eq 4} {AppendUser; Break}
        {$_ -eq 5} {AppendWebsite; Break}
        {$_ -eq 6} {Edit; Break}
        Default    {About}
    }
    Write-Host ����������ز˵�...
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}Until ($input -eq '0')

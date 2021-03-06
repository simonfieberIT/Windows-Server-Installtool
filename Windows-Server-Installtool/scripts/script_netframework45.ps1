﻿    ###    Simon Fieber IT-Services    ###
    ###     Coded by: Simon Fieber     ###
    ###     Visit:  simonfieber.it     ###

Clear-Host

### Startbildschirm ###
    function startbildschirm {
        Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗"
        Write-Host "║ Windows Server-Manager Tool                                                  ║"
        Write-Host "║                                                                              ║"
        Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝"
    }

### .NET-Framework Version ermitteln ###
if([System.Environment]::OSVersion.Version.Major -eq 10){
    $NET4 = "4.6"
        }
else {
    $NET4 = "4.5"
}

### Menü ###
function netframework {
    do {
        Clear-Host
        startbildschirm
            Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
            Write-Host "   ║ .NET Framework $NET4                                                        ║"
            Write-Host "   ╠══════════════════════                                                     ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ║ Möchten Sie .NET Framework installieren oder deinstallieren?              ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ║ [ 1 ] Installieren                 ║ [ 2 ] Deinstallieren                 ║"
            Write-Host "   ║                                    ║                                      ║"
            Write-Host "   ╠════════════════════════════════════╩══════════════════════════════════════╣"
            Write-Host "   ║ [ X ] Zurück zum Hauptmenü                                                ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
            Write-Host ""
            $input = Read-Host "Bitte wählen Sie"

            switch ($input) {
                '1' {netframework-install}
                '2' {netframework-uninstall}
                'x' {wsitool} # Zurück ins Hauptmenü #
                '0' {wsitool} # Zurück ins Hauptmenü #
            } pause }
        until ($input -eq 'x')
}

### .NET Framework installieren ###
function netframework-install {
    Clear-Host
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ .NET Framework $NET4                                                        ║"
        Write-Host "   ╠══════════════════════                                                     ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ║ .NET Framework $NET4 wird installiert...                                    ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        Write-Host ""
        Start-Sleep -Milliseconds 1500
        Install-WindowsFeature NET-Framework-45-Core -source \\network\share\sxs | Out-Null
        Clear-Host
        startbildschirm
            Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
            Write-Host "   ║ .NET Framework $NET4                                                        ║"
            Write-Host "   ╠══════════════════════                                                     ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ║ .NET Framework $NET4 wurde erfolgreich installiert...                       ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3000
    netframework
}

### .NET Framework deinstallieren ###
function netframework-uninstall {
    Clear-Host
    startbildschirm
        Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
        Write-Host "   ║ .NET Framework $NET4                                                        ║"
        Write-Host "   ╠══════════════════════                                                     ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ║ .NET Framework $NET4 wird deinstalliert...                                  ║"
        Write-Host "   ║                                                                           ║"
        Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
        Write-Host ""
        Start-Sleep -Milliseconds 1500
        Uninstall-WindowsFeature NET-Framework-45-Core | Out-Null
        Clear-Host
        startbildschirm
            Write-Host "   ╔═══════════════════════════════════════════════════════════════════════════╗"
            Write-Host "   ║ .NET Framework $NET4                                                        ║"
            Write-Host "   ╠══════════════════════                                                     ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ║ .NET Framework $NET4 wurde erfolgreich deinstalliert...                     ║"
            Write-Host "   ║                                                                           ║"
            Write-Host "   ╚═══════════════════════════════════════════════════════════════════════════╝"
            Start-Sleep -Milliseconds 3000
    netframework
}

### Root-Verzeichnis ermitteln, zum öffnen des Programmcodes ###
function Get-ScriptDirectory {
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}
 
$installpath = Get-ScriptDirectory
$scriptpath = "\tool_srvmanager.ps1"
$fullscriptpath = $installpath + $scriptpath

### Zurück zum Windows Server Installtool ###
function wsmtool {
        $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $princ = New-Object System.Security.Principal.WindowsPrincipal($identity)
        if(!$princ.IsInRole( `
            [System.Security.Principal.WindowsBuiltInRole]::Administrator))
            {
                $powershell = [System.Diagnostics.Process]::GetCurrentProcess()
                $psi = New-Object System.Diagnostics.ProcessStartInfo $powerShell.Path
                $script = $fullscriptpath
                $prm = $script
                    foreach($a in $args) {
                        $prm += ' ' + $a
                    }
                $psi.Arguments = $prm
                $psi.Verb = "runas"
                [System.Diagnostics.Process]::Start($psi) | Out-Null
                return;
            }
    ### Falls Adminrechte nicht erfordert werden können, ###
    ### soll das Script trotzdem ausgeführt werden.      ###
    & $fullscriptpath
}

### Start ###
netframework
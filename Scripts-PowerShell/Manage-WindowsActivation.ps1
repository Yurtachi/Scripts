# Função para obter a chave de produto OEM do firmware
function Get-OEMKey {
    try {
        $oemKey = (Get-WmiObject -Query "SELECT * FROM SoftwareLicensingService").OA3xOriginalProductKey
        return $oemKey
    } catch {
        return $null
    }
}

# Função para desinstalar qualquer chave existente
function Remove-CurrentKey {
    try {
        Start-Process -FilePath "cscript.exe" -ArgumentList "//NoLogo", "C:\Windows\System32\slmgr.vbs", "/upk" -NoNewWindow -Wait
    } catch {
        # Nothing
    }
}

# Função para instalar uma nova chave de produto
function Install-Key {
    param (
        [string]$Key
    )
    try {
        Start-Process -FilePath "cscript.exe" -ArgumentList "//NoLogo", "C:\Windows\System32\slmgr.vbs", "/ipk", $Key -NoNewWindow -Wait
    } catch {
        # # Nothing
    }
}

# Função para ativar o Windows
function Activate-Windows {
    try {
        Start-Process -FilePath "cscript.exe" -ArgumentList "//NoLogo", "C:\Windows\System32\slmgr.vbs", "/ato" -NoNewWindow -Wait
    } catch {
        # Nothing
    }
}

# Fluxo principal
$oemKey = Get-OEMKey

if ($oemKey) {
    Remove-CurrentKey
    Install-Key -Key $oemKey
    Activate-Windows
}

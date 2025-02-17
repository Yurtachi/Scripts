# Verifica se o usuário "support" está ativado
$user = Get-LocalUser -Name "support"

# Se o usuário estiver ativado, retorna código 0 
if ($user.Enabled) {
    Write-Host ('Ola')
    exit 0
} else {
    # Caso contrário, retorna código 1 
    Write-Host ('Ola')
    exit 1
}

# Ativa o usuário "support" caso esteja desativado
$user = Get-LocalUser -Name "support"

if (-not $user.Enabled) {
    $user | Enable-LocalUser
}

# Verifica se a remediação foi bem-sucedida
$user = Get-LocalUser -Name "support"

# Se o usuário estiver ativado, retorna código 0 (sucesso)
if ($user.Enabled) {
    exit 0
} else {
    # Caso contrário, retorna código 1 (falha)
    exit 1
}

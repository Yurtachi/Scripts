# Função para solicitar o servidor e credenciais
function Solicita-ServidorECredenciais {
    $server = Read-Host "Digite o nome do servidor Hyper-V"
    $credential = Get-Credential -Message "Insira as credenciais para acessar $server"
    return @($server, $credential)
}

# Função para listar VMs
function Lista-VMs {
    param ($server, $credential)
    try {
        $vms = Invoke-Command -ComputerName $server -Credential $credential -ScriptBlock {
            Get-VM | Select-Object Name, State
        }
        
        Write-Host "`n--- VMs Disponíveis no Servidor '$server' ---" -ForegroundColor Cyan
        $vms | Format-Table -AutoSize
    }
    catch {
        Write-Host "Erro: Não foi possível conectar ao servidor Hyper-V '$server'. Verifique as credenciais e a conexão." -ForegroundColor Red
        exit
    }
}

# Função para gerenciar snapshots
function Gerencia-Snapshots {
    param ($server, $credential, $vmName, $opcao)
    Invoke-Command -ComputerName $server -Credential $credential -ScriptBlock {
        param ($vmName, $opcao)
        
        # Verifica se a VM existe
        if (!(Get-VM -Name $vmName -ErrorAction SilentlyContinue)) {
            Write-Host "Erro: A VM '$vmName' não foi encontrada no servidor Hyper-V!" -ForegroundColor Red
            exit
        }

        switch ($opcao) {
            "1" {
                $snapshotName = "Snapshot_" + (Get-Date -Format "yyyy-MM-dd_HH-mm-ss")
                Checkpoint-VM -Name $vmName -SnapshotName $snapshotName
                Write-Host "Snapshot '$snapshotName' criado com sucesso para a VM '$vmName'" -ForegroundColor Green
            }
            "2" {
                $snapshots = Get-VMSnapshot -VMName $vmName
                if ($snapshots) {
                    Write-Host "`nSnapshots disponíveis para '$vmName':" -ForegroundColor Cyan
                    $snapshots | Select-Object Name, CreationTime | Format-Table -AutoSize
                    $snapshotToRestore = Read-Host "Digite o nome exato do snapshot para restaurar"
                    Restore-VMSnapshot -VMName $vmName -Name $snapshotToRestore -Confirm:$false
                    Write-Host "Snapshot '$snapshotToRestore' restaurado com sucesso!" -ForegroundColor Green
                } else {
                    Write-Host "Nenhum snapshot encontrado para a VM '$vmName'" -ForegroundColor Yellow
                }
            }
            "3" {
                $snapshots = Get-VMSnapshot -VMName $vmName
                if ($snapshots) {
                    Write-Host "`nSnapshots disponíveis para '$vmName':" -ForegroundColor Cyan
                    $snapshots | Select-Object Name, CreationTime | Format-Table -AutoSize
                } else {
                    Write-Host "Nenhum snapshot encontrado para a VM '$vmName'" -ForegroundColor Yellow
                }
            }
            "4" {
                $snapshots = Get-VMSnapshot -VMName $vmName
                if ($snapshots) {
                    Write-Host "`nSnapshots disponíveis para exclusão na VM '$vmName':" -ForegroundColor Cyan
                    $snapshots | Select-Object Name, CreationTime | Format-Table -AutoSize
                    $snapshotToDelete = Read-Host "Digite o nome exato do snapshot para excluir"
                    Remove-VMSnapshot -VMName $vmName -Name $snapshotToDelete -Confirm:$false
                    Write-Host "Snapshot '$snapshotToDelete' excluído com sucesso!" -ForegroundColor Green
                } else {
                    Write-Host "Nenhum snapshot encontrado para a VM '$vmName'" -ForegroundColor Yellow
                }
            }
            default {
                Write-Host "Opção inválida! Escolha entre 1 a 4." -ForegroundColor Red
            }
        }
    } -ArgumentList $vmName, $opcao
}

# Script Principal
$serverAndCredentials = Solicita-ServidorECredenciais
$server = $serverAndCredentials[0]
$credential = $serverAndCredentials[1]

Lista-VMs -server $server -credential $credential

$vmName = Read-Host "`nDigite o nome exato da VM que deseja gerenciar"

Write-Host "`nEscolha uma opção:"
Write-Host "1 - Criar um Snapshot"
Write-Host "2 - Restaurar um Snapshot"
Write-Host "3 - Listar Snapshots disponíveis"
Write-Host "4 - Excluir um Snapshot específico"
$opcao = Read-Host "Digite o número da opção desejada"

Gerencia-Snapshots -server $server -credential $credential -vmName $vmName -opcao $opcao
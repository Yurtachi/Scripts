# 📜 Scripts PowerShell  
Esta pasta contém scripts para automação e gerenciamento de TI usando PowerShell.

## 🎯 Scripts Disponíveis

**Manage-WindowsOEMKey.ps1**:
- Script para obter a chave de produto OEM do firmware, remover qualquer chave existente, instalar uma nova chave e ativar o Windows.

 **Manage-HyperVSnapshots.ps1**:
- Script para gerenciar snapshots de VMs no Hyper-V, permitindo criar, restaurar, listar e excluir snapshots de maneira fácil e interativa.


### 🏢 Intune

**detect.ps1**:
- Script de detecção. Verifica se o usuário `support` está ativado e retorna `0` (ativo) ou `1` (inativo).

**remediate.ps1**:
- Script de remediação. Caso o `detect.ps1` retorne `1`, o script `remediate.ps1` ativa o usuário `support`.

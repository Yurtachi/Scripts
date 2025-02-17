# 📜 Scripts Batch  
Esta pasta contém scripts para automação e gerenciamento de TI usando Batch.

## 🎯 Scripts Disponíveis

**Network_scan.bat**:
- Script para escanear uma rede e listar os IPs ativos.



### 🏢 Intune

**detect.ps1**:
- Script de detecção. Verifica se o usuário `support` está ativado e retorna `0` (ativo) ou `1` (inativo).

**remediate.ps1**:
- Script de remediação. Caso o `detect.ps1` retorne `1`, o script `remediate.ps1` ativa o usuário `support`.

# 🔒 Segurança e Boas Práticas

## ⚠️ **IMPORTANTE - Informações Sensíveis**

### **NÃO inclua no Git:**
- ✅ Arquivos `.pem` (chaves privadas)
- ✅ Credenciais AWS
- ✅ Account IDs reais
- ✅ Emails pessoais
- ✅ IPs públicos de instâncias

### **Arquivos Protegidos pelo .gitignore:**
```
*.pem          # Chaves SSH privadas
*.key          # Qualquer chave privada
.aws/          # Diretório de credenciais AWS
credentials.*  # Arquivos de credenciais
```

## 🛡️ **Antes de Fazer Push:**

### **1. Verificar Arquivos:**
```bash
git status
# Certifique-se que nenhum .pem está listado
```

### **2. Substituir Informações Reais:**
- Account ID: `[SEU-ACCOUNT-ID]`
- Email: `[seu-email@exemplo.com]`
- KeyPair: `[sua-chave]`

### **3. Gerar Nova KeyPair:**
```bash
# Cada usuário deve criar sua própria chave
.\create-keypair.bat
```

## 🔐 **Configuração Segura:**

### **Para Usuários do GitHub:**
1. **Clone o repositório**
2. **Configure suas credenciais AWS**
3. **Crie sua própria KeyPair**
4. **Execute os scripts normalmente**

### **Nunca Compartilhe:**
- Chaves privadas (.pem)
- Access Keys AWS
- Secret Keys AWS
- Account IDs reais

## 📋 **Checklist de Segurança:**
- [ ] .gitignore configurado
- [ ] Arquivos .pem removidos
- [ ] Account IDs substituídos
- [ ] Emails genéricos no código
- [ ] Documentação atualizada
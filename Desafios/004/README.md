# Sistema de Monitoramento EC2 com CloudWatch e SNS

## Descrição do Projeto

Sistema completo de **monitoramento automático** que demonstra a integração entre serviços AWS para criar uma infraestrutura inteligente. O sistema monitora continuamente uma instância EC2 e envia alertas automáticos por email quando a CPU ultrapassa 70%.

## 🎯 Objetivo

Demonstrar **Infrastructure as Code (IaC)** e **automação prática** usando CloudFormation para criar uma solução de monitoramento que:

- Detecta automaticamente problemas de performance
- Envia notificações em tempo real
- Funciona 100% dentro do AWS Free Tier

## 🏗️ Arquitetura e Serviços AWS Utilizados

### **EC2 (Elastic Compute Cloud)**

- **Instância**: t2.micro (Free Tier)
- **AMI**: Amazon Linux 2
- **Função**: Servidor monitorado que simula cargas de trabalho
- **UserData**: Script de inicialização que instala ferramentas de teste

### **CloudWatch (Monitoramento)**

- **Métricas**: CPUUtilization coletada automaticamente
- **Alarme**: Threshold de 70% de CPU
- **Avaliação**: 2 períodos de 5 minutos (10 min total)
- **Função**: Detecta anomalias de performance

### **SNS (Simple Notification Service)**

- **Tópico**: AlertTopic para distribuição de mensagens
- **Protocolo**: Email para notificações
- **Função**: Entrega automática de alertas

### **IAM (Identity and Access Management)**

- **Security Group**: Controle de acesso SSH (porta 22)
- **Permissões**: Acesso mínimo necessário para funcionamento

### **CloudFormation (Infrastructure as Code)**

- **Template**: Definição declarativa de toda infraestrutura
- **Stack**: Gerenciamento unificado de recursos
- **Parâmetros**: Email e KeyPair configuráveis

## Processo de Deploy Realizado

### **Passo 1: Preparação**

```bash
# Criar KeyPair para acesso SSH
.\create-keypair.bat
# Nome usado: [sua-keypair-name]
```

### **Passo 2: Deploy da Infraestrutura**

```bash
# Deploy completo via CloudFormation
.\deploy.bat
# Parâmetros fornecidos:
# - Email: [seu-email@exemplo.com]
# - KeyPair: [sua-keypair-name]
```

### **Passo 3: Confirmação SNS**

- Email recebido: "AWS Notification - Subscription Confirmation"
- Ação: Clique em "Confirm subscription"
- Status: Subscription confirmed

### **Passo 4: Verificação da Stack**

```bash
# Verificar recursos criados
.\check-stack.bat
# Status: CREATE_COMPLETE
# Outputs: InstanceId, PublicIP, SNSTopicArn, etc.
```

## 🧪 Testes Realizados

### **Teste 1: Simulação Manual de Alarme**

```bash
.\test-alarm.bat
# Ação: Forçou estado ALARM manualmente
# Resultado: Email de alerta recebido em segundos
# Restauração: Estado OK após 30 segundos
```

### **Teste 2: Monitoramento em Tempo Real**

```bash
.\monitor-alarm.bat
# Função: Acompanhar status do alarme continuamente
# Resultado: Visualização em tempo real das métricas
```

## 📧 Exemplo de Email de Alerta Recebido

```
De: AWS Notifications <no-reply@sns.amazonaws.com>
Assunto: ALARM: "[NOME-DO-ALARME]" in [SUA-REGIAO-COMPLETA]

AlarmName: [NOME-DO-ALARME]
AlarmDescription: Alarme disparado quando CPU da instância > 70%
AWSAccountId: [SEU-ACCOUNT-ID]
NewStateValue: ALARM
NewStateReason: Teste manual do sistema de alertas
StateChangeTime: 2025-01-23T21:30:00.000+0000
Region: [SUA-REGIAO-COMPLETA]  # Ex: South America (Sao Paulo)
```

## ⏱️ Timeline de Funcionamento

### **Monitoramento Normal:**

1. **Contínuo**: CloudWatch coleta métricas de CPU a cada 5 minutos
2. **Avaliação**: Alarme verifica se CPU > 70% por 2 períodos consecutivos
3. **Estado**: OK enquanto CPU < 70%

### **Cenário de Alerta:**

1. **0min**: CPU ultrapassa 70% (stress test ou carga real)
2. **5min**: Primeira métrica coletada (CPU alta)
3. **10min**: Segunda métrica coletada (CPU ainda alta)
4. **10min**: Alarme dispara (2 períodos > threshold)
5. **Imediato**: SNS envia email automaticamente
6. **Recuperação**: Quando CPU normaliza, alarme volta para OK

## 💰 Custos e Free Tier

### **Recursos Gratuitos Utilizados:**

- **EC2 t2.micro**: 750 horas/mês (suficiente para 24/7)
- **CloudWatch**: 10 alarmes personalizados gratuitos
- **SNS**: 1.000 notificações por email/mês
- **CloudFormation**: Sem custo adicional
- **Transferência de dados**: Mínima (dentro do free tier)

### **Estimativa de Uso:**

- **Instância EC2**: ~720h/mês (rodando continuamente)
- **Métricas CloudWatch**: ~8.640 pontos/mês (1 a cada 5min)
- **Alertas SNS**: ~1-10 emails/mês (dependendo dos incidentes)

## 🔧 Arquivos e Scripts Criados

```
004/
├── template.yaml          # CloudFormation - Infraestrutura completa
├── deploy.bat            # Deploy automatizado com parâmetros
├── create-keypair.bat    # Criação de chave SSH
├── check-stack.bat       # Verificação de status da stack
├── test-alarm.bat        # Teste manual de alarme (USADO)
├── monitor-alarm.bat     # Monitoramento em tempo real
├── cleanup.bat           # Limpeza completa de recursos
├── .gitignore            # Proteção de arquivos sensíveis
├── SECURITY.md           # Guia de segurança
└── README.md             # Esta documentação
```

## 🎯 Resultados Obtidos

### ✅ **Sucessos Alcançados:**

1. **Infraestrutura automatizada** criada via CloudFormation
2. **Monitoramento funcional** com CloudWatch
3. **Alertas por email** funcionando via SNS
4. **Testes validados** com diferentes cenários
5. **Documentação completa** para reprodução
6. **100% Free Tier** - sem custos adicionais

### 📊 **Métricas de Sucesso:**

- **Deploy**: 100% automatizado
- **Tempo de setup**: ~10 minutos
- **Tempo de resposta**: Alertas em segundos
- **Confiabilidade**: Sistema funcionando conforme esperado

## 🔄 Como Reproduzir Este Teste

### **Pré-requisitos:**

- Conta AWS com Free Tier ativo
- AWS CLI configurado
- Windows PowerShell ou Command Prompt

### **Reprodução Passo a Passo:**

1. **Clone/Download dos arquivos**
2. **Navegue para a pasta 004**
3. **Execute os comandos na sequência:**

```bash
# 1. Criar KeyPair
.\create-keypair.bat

# 2. Deploy da infraestrutura
.\deploy.bat

# 3. Confirmar email SNS (verificar caixa de entrada)

# 4. Verificar se tudo foi criado
.\check-stack.bat

# 5. Testar o sistema de alertas
.\test-alarm.bat

# 6. (Opcional) Monitorar em tempo real
.\monitor-alarm.bat

# 7. Limpar recursos quando terminar
.\cleanup.bat
```

### **Validação do Sucesso:**

- ✅ Stack com status CREATE_COMPLETE
- ✅ Email de confirmação SNS recebido e confirmado
- ✅ Email de alerta recebido durante o teste
- ✅ Instância EC2 rodando e acessível
- ✅ Alarme CloudWatch funcionando

## 🎓 Aprendizados e Conceitos Demonstrados

### **Infrastructure as Code (IaC):**

- Definição declarativa de infraestrutura
- Versionamento e reprodutibilidade
- Automação completa de deploy

### **Monitoramento e Observabilidade:**

- Coleta automática de métricas
- Definição de thresholds inteligentes
- Alertas proativos

### **Integração de Serviços AWS:**

- EC2 + CloudWatch + SNS
- Comunicação entre serviços
- Fluxo de dados automatizado

### **Boas Práticas:**

- Uso de parâmetros configuráveis
- Documentação completa
- Scripts de automação
- Limpeza de recursos

## 🔧 Personalização Possível

### **Parâmetros Configuráveis:**

- **EmailAddress**: Email para receber alertas
- **KeyPairName**: Nome da chave SSH

### **Modificações no Template:**

```yaml
# Ajustar threshold do alarme
Threshold: 70 # Alterar para 50, 80, 90, etc.

# Modificar período de avaliação
Period: 300 # 5 minutos
EvaluationPeriods: 2 # 2 períodos = 10 min total

# Alterar tipo de instância (dentro do Free Tier)
InstanceType: t2.micro # Manter para Free Tier
```

### **Extensões Possíveis:**

- Adicionar mais métricas (Memory, Disk)
- Múltiplos canais de notificação (SMS, Slack)
- Dashboard CloudWatch personalizado
- Auto Scaling baseado em métricas

## 🔒 Informações Sensíveis e Placeholders

### ⚠️ **IMPORTANTE - Dados Substituídos por Segurança:**

Todos os dados sensíveis foram substituídos por **placeholders genéricos** para segurança:

- **Account ID**: `[SEU-ACCOUNT-ID]` (substitua pelo seu)
- **Email**: `[seu-email@exemplo.com]` (use seu email real)
- **KeyPair**: `[sua-keypair-name]` (crie sua própria chave)
- **Região AWS**: `[SUA-REGIAO]` (ex: us-east-1, sa-east-1, eu-west-1)
- **Região Completa**: `[SUA-REGIAO-COMPLETA]` (ex: South America (Sao Paulo))
- **Nome da Stack**: `[NOME-DA-STACK]` (ex: ec2-monitoring)
- **Nome do Alarme**: `[NOME-DO-ALARME]` (ex: EC2-CPU-High-Alert)
- **Caminho AWS CLI**: `[CAMINHO-DO-AWS-CLI]` (caminho de instalação)
- **AMI ID**: `[AMI-ID-DA-SUA-REGIAO]` (use AMI mais recente)
- **Timestamps**: Dinâmicos nos scripts de monitoramento

### 🛡️ **Antes de Usar:**

1. **Substitua os placeholders** pelos seus valores reais
2. **Configure o caminho do AWS CLI** (se diferente do padrão)
3. **Configure sua região AWS** em todos os scripts
4. **Defina o nome da stack** (ou use ec2-monitoring)
5. **Crie sua própria KeyPair** usando `create-keypair.bat`
6. **Use seu email** no parâmetro EmailAddress
7. **Encontre a AMI ID** mais recente para sua região

### 📝 **Arquivos com Placeholders:**
- `README.md` - Account ID e nomes de exemplo
- `template.yaml` - AMI ID e região
- `*.bat` - Região AWS em todos os scripts
- `monitor-alarm.bat` - Timestamps dinâmicos

## 🏆 Conclusão

Este projeto demonstra com sucesso a criação de uma **infraestrutura inteligente** que:

- **Monitora automaticamente** recursos AWS
- **Detecta problemas** antes que afetem usuários
- **Notifica responsáveis** em tempo real
- **Funciona 24/7** sem intervenção manual
- **Custa zero** dentro do Free Tier

Um exemplo prático de como a **automação** e **monitoramento** podem transformar a gestão de infraestrutura, proporcionando **visibilidade**, **confiabilidade** e **resposta rápida** a incidentes.

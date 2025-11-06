# **RELATÓRIO DE IMPLEMENTAÇÃO DE MEDIDAS DE SEGURANÇA AWS**

**Data:** 06-11-2025
**Empresa:** Abstergo Industries
**Responsável:** Ingrid Silva

---

## **Introdução**

Este relatório apresenta o processo de implementação de **medidas de segurança na AWS**, conduzido por **Ingrid Silva**, com o objetivo de **proteger os dados sensíveis da Abstergo Industries** e **garantir conformidade com normas do setor farmacêutico**.
A proposta contempla três ações iniciais que fortalecem a **gestão de identidade**, o **controle de acesso** e a **proteção de dados** na nuvem.

## **Descrição do Projeto**

O projeto foi estruturado em **três etapas**, cada uma voltada a um aspecto essencial da **segurança em ambiente cloud AWS**.

### **Etapa 1**

- **Nome da ferramenta:** AWS Identity and Access Management (IAM)
- **Foco da ferramenta:** Controle de identidade e permissões de acesso
- **Descrição de caso de uso: **O AWS IAM foi configurado para criar **usuários e grupos com políticas de acesso baseadas em papéis**, garantindo que cada colaborador tenha **acesso apenas aos recursos necessários** para sua função. Além disso, foi ativada a **autenticação multifator (MFA)** para administradores e usuários com permissões elevadas, reforçando a segurança contra acessos não autorizados.

### **Etapa 2**

- **Nome da ferramenta:** AWS CloudTrail
- **Foco da ferramenta:** Auditoria e monitoramento de atividades
- **Descrição de caso de uso:
  **O AWS CloudTrail foi implementado para **registrar todas as ações executadas dentro do ambiente AWS**, incluindo alterações em configurações, acessos e movimentações de dados. Esses logs são armazenados de forma segura no Amazon S3 e podem ser analisados para **detectar comportamentos suspeitos**, **garantir rastreabilidade** e **atender requisitos de compliance** (como LGPD e ANVISA).

### **Etapa 3**

- **Nome da ferramenta:** AWS Key Management Service (KMS)
- **Foco da ferramenta:** Criptografia e gerenciamento de chaves
- **Descrição de caso de uso:** O AWS KMS foi utilizado para **gerar e gerenciar chaves de criptografia** usadas na proteção de dados armazenados em bancos de dados, buckets S3 e serviços de backup. Essa medida garante que **informações confidenciais de clientes, fornecedores e fórmulas farmacêuticas** permaneçam protegidas mesmo em caso de acesso indevido, além de facilitar a **integração com outros serviços AWS** que utilizam criptografia nativa.

## **Conclusão**

A implementação das medidas de segurança com **AWS IAM**, **CloudTrail** e **KMS** fortaleceu significativamente o ambiente da Abstergo Industries, garantindo **controle granular de acesso**, **rastreabilidade total das operações** e **proteção criptográfica dos dados sensíveis**.

## **Anexos**

- [Manual de Boas Práticas de Segurança AWS](https://docs.aws.amazon.com/pt_br/securityhub/latest/userguide/fsbp-standard.html)
- [Políticas de Acesso IAM ](https://aws.amazon.com/pt/iam/?trk=c6d967d2-2075-4de1-b45d-326daf1783ab&sc_channel=ps&ef_id=Cj0KCQiAq7HIBhDoARIsAOATDxANG-mDt4502W4UD35Y0Y071i9Y3UKEZC5w1I3MwmRfm_4V3Vut4bMaAjSqEALw_wcB:G:s&s_kwcid=AL!4422!3!780730116233!p!!g!!iam!23183030059!186749592399&gad_campaignid=23183030059&gbraid=0AAAAADjHtp8nWAJlfBwT84CLexHOpL4g5&gclid=Cj0KCQiAq7HIBhDoARIsAOATDxANG-mDt4502W4UD35Y0Y071i9Y3UKEZC5w1I3MwmRfm_4V3Vut4bMaAjSqEALw_wcB)

---

**Assinatura do Responsável pelo Projeto:
** **Ingrid Silva**

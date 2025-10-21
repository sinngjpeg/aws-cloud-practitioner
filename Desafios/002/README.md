# Processador de Pedidos com AWS Step Functions

## 🎯 Objetivo
Este projeto tem como objetivo demonstrar o uso do **AWS Step Functions** para orquestrar o fluxo de processamento de pedidos, integrando funções **AWS Lambda**.

---

## ⚙️ Arquitetura
O fluxo é composto pelas seguintes etapas:
1. **Validar Pedido** – verifica se o pedido contém os campos obrigatórios.
2. **Registrar Pedido** – simula o salvamento no banco de dados DynamoDB.
3. **Processar Pagamento** – simula uma aprovação ou reprovação.
4. **Notificar Resultado** – informa o status final do pedido.

---

## 🧩 Serviços Utilizados
- AWS Step Functions
- AWS Lambda
- Amazon DynamoDB (simulado)


---

## 🧪 Como testar
1. Crie as funções Lambda no console da AWS com os códigos fornecidos.
2. Copie o JSON do workflow e importe no Step Functions.
3. Execute a State Machine com o seguinte **input** de teste:

```json
 {
  "pedidoId": "123",
  "nomeCliente": "Ingrid",
  "valor": 120.5
}  
```

Se tudo ocorrer bem, o output esperado será:

```json
{
  "pedidoId": "123",
  "nomeCliente": "Ingrid",
  "valor": 120.5,
  "status": "PAGAMENTO_APROVADO",
  "statusFinal": "SUCESSO"
}
```


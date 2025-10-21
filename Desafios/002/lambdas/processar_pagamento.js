exports.handler = async (event) => {
    console.log("Processando pagamento do pedido:", event.pedidoId);

    // Simula aprovação ou recusa do pagamento (70% de chance de aprovação)
    const aprovado = Math.random() > 0.3;

    if (!aprovado) {
        throw new Error("Pagamento recusado");
    }

    return {
        ...event,
        status: "PAGAMENTO_APROVADO"
    };
};
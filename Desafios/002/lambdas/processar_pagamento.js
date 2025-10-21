exports.handler = async (event) => {
    console.log("Processando pagamento:", event);

    const aprovado = Math.random() > 0.3; // 70% de chance de sucesso

    if (!aprovado) {
        throw new Error("Pagamento recusado");
    }

    return { ...event, status: "PAGAMENTO_APROVADO" };
};
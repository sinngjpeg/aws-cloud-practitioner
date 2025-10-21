exports.handler = async (event) => {
    console.log("Validando pedido:", event);

    if (!event.nome || !event.valor) {
        throw new Error("Pedido inválido: faltam campos obrigatórios");
    }

    return { ...event, status: "VALIDADO" };
};
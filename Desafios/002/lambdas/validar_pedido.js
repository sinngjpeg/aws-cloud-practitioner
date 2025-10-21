exports.handler = async (event) => {
    console.log("Validando pedido:", event);

    if (!event.pedidoId) {
        throw new Error("Pedido inválido: falta o pedidoId");
    }

    return {
        ...event,
        status: "VALIDADO"
    };
};
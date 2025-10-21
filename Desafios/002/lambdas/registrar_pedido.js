exports.handler = async (event) => {
    console.log("Registrando pedido:", event);

    // Simula geração de um ID de pedido único se não existir
    const pedidoId = event.pedidoId || Date.now().toString();

    return {
        ...event,
        pedidoId,
        status: "REGISTRADO"
    };
}; exports.handler = async (event) => {
    console.log("Registrando pedido:", event);
    return { ...event, pedidoId: Date.now().toString(), status: "REGISTRADO" };
};
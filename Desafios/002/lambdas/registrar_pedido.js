exports.handler = async (event) => {
    console.log("Registrando pedido:", event);
    return { ...event, pedidoId: Date.now().toString(), status: "REGISTRADO" };
};
exports.handler = async (event) => {
    console.log("Pedido processado com sucesso:", event.pedidoId);

    return {
        ...event,
        statusFinal: "SUCESSO"
    };
};
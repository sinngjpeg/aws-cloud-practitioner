exports.handler = async (event) => {
    console.error("Ocorreu um erro no processamento do pedido:", event);

    return {
        ...event,
        statusFinal: "ERRO"
    };
};
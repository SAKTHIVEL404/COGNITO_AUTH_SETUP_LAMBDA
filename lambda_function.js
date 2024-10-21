lambda
exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello, World! This is your Lambda function responding!",
            input: event,
        }),
    };

    return response;
};

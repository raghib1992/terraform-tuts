const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

exports.handler = async (event) => {
  try {
    console.log("Event received:", JSON.stringify(event));

    const body = JSON.parse(event.body);

    const params = {
      MessageBody: JSON.stringify(body),
      QueueUrl: process.env.QUEUE_URL,
    };

    console.log("Sending message:", params);

    await sqs.sendMessage(params).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Message queued successfully" }),
    };
  } catch (err) {
    console.error("Lambda error:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Internal server error", error: err.message }),
    };
  }
};
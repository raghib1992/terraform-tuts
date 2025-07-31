const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

const QUEUE_MAP = {
  "/bucket": process.env.QUEUE_SUBMIT_PAYMENT,
  "/bucket/id": process.env.QUEUE_TRACK_STATUS
};

exports.handler = async (event) => {
  try {
    const path = event.resource || event.path;
    console.log("Received path:", path);

    const queueUrl = QUEUE_MAP[path];

    if (!queueUrl) {
      console.error("No queue mapped for path:", path);
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Invalid path. No queue assigned." })
      };
    }

    const body = JSON.parse(event.body);

    const params = {
      QueueUrl: queueUrl,
      MessageBody: JSON.stringify(body)
    };

    console.log("Sending to SQS:", params);
    await sqs.sendMessage(params).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Message queued", queue: path })
    };

  } catch (err) {
    console.error("Error occurred:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to queue message", details: err.message })
    };
  }
};

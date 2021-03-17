let AWS = require("aws-sdk");
let dynamodb = new AWS.DynamoDB({ apiVersion: "2012-08-10" });

exports.lambdaHandler = async () => {
  let params = {
    TableName: "DuClassUsers",
  };
  let result = await dynamodb
    .scan(params, function (err, data) {
      if (err) console.log(err, err.stack);
      // an error occurred
      else console.log(data); // successful response
    })
    .promise();
  //This is for CORS
  return {
    headers: {
      //IMPORTANT: this header is REQUIRED to enable CORS on the front-end.
      "X-Requested-With": "*",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers":
        "Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with",
      "Access-Control-Allow-Methods": "PUT,POST,GET,OPTIONS",
    },
    statusCode: 200,
    body: JSON.stringify(result),
  };
};

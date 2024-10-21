**Lambda Function with API Gateway Integration and Authorization**

**Introduction**
This project demonstrates how to create an AWS Lambda function, integrate it with API Gateway, and secure the API using an authorization mechanism (Lambda Authorizer or Cognito User Pool).

**Pre-requisites**
Before you start, ensure that you have the following:

An AWS account.
1)AWS CLI or AWS Management Console access.
2)Node.js or Python (for Lambda function development).
3)Basic knowledge of AWS Lambda, API Gateway, and IAM roles.

**Step-by-Step Instructions**

**I) Create a Lambda Function
Navigate to AWS Lambda Console:**
1)Go to the AWS Management Console and search for Lambda.
Create a New Lambda Function:
2)Click on Create function.
3)Choose Author from scratch.
4)Provide a function name (e.g., MyLambdaFunction).
5)Choose Node.js or Python as the runtime.
6)Click Create function.
7)On that particular console defaultly we have have a lambda code depends upon our neccesity we can change our
8)Edit the function code inline or upload a .zip package with the code.(if we go with terraform)

**Example Lambda function (Node.js):
javascript**
Copy code
exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};
Save the function.

2)Test the Lambda Function:
3)Click Test and configure a test event.
Execute the function to ensure it's working.

**II) Integrate Lambda with API Gateway
Navigate to API Gateway Console:**
1)Go to the AWS Management Console and search for API Gateway.
2)Create a New API:
3)Select Create API > REST API.
4)Provide an API name and description.
5)Click Create API.
6)Create a Resource:
7)In the Resources section, click Actions > Create Resource.
8)Provide a name (e.g., /hello) and click Create Resource.
9)Create a Method (e.g., GET):
10)Select the newly created resource (e.g., /hello).
Click Actions > Create Method > Choose GET.
11)Choose Lambda Function as the integration type.
Select the region and enter the Lambda function name (MyLambdaFunction).
12)Click Save and allow API Gateway to invoke the Lambda function.
Enable CORS (Optional):

Deploy the API:
1)Click Actions > Deploy API.
2)Create a new stage (e.g., dev) and click Deploy.
Copy the Invoke URL of the API.

**3. Set Up Authorization**
Option 1: Using Lambda Authorizer
Create a Lambda Authorizer:

In Lambda, create a new function (e.g., MyAuthFunction).
Write a function to validate the token and return an IAM policy:
javascript
Copy code
exports.handler = async (event) => {
    const token = event.authorizationToken;
    if (token === "valid-token") {
        return generatePolicy('user', 'Allow', event.methodArn);
    } else {
        return generatePolicy('user', 'Deny', event.methodArn);
    }
};

const generatePolicy = (principalId, effect, resource) => {
    return {
        principalId,
        policyDocument: {
            Version: '2012-10-17',
            Statement: [{
                Action: 'execute-api:Invoke',
                Effect: effect,
                Resource: resource,
            }],
        },
    };
};
Add Lambda Authorizer in API Gateway:

Go to API Gateway > Your API > Authorizers.
Click Create New Authorizer.
Set the name (MyLambdaAuth), select Lambda as the authorizer type.
Select the Lambda function (MyAuthFunction).
Set Token Source as Authorization header.
Attach Authorizer to API Method:

In Resources, select the method (e.g., GET /hello).
In Method Request, select Authorization and choose MyLambdaAuth.
Option 2: Using Cognito User Pool Authorizer
Create a Cognito User Pool:

Go to Cognito in AWS.
Create a new User Pool and configure the basic settings.
Under App Clients, create a new app client (this will generate a Client ID).
Add Cognito Authorizer in API Gateway:

Go to API Gateway > Your API > Authorizers.
Click Create New Authorizer.
Set the name (MyCognitoAuth), select Cognito as the authorizer type.
Choose your Cognito User Pool.
Optionally, specify the App Client ID for validation.
Attach Authorizer to API Method:

In Resources, select the method (e.g., GET /hello).
In Method Request, select Authorization and choose MyCognitoAuth.
4. Test the API with Authorization
Lambda Authorizer:

Make a request to the API using a valid token in the Authorization header.
sql
Copy code
curl -X GET https://<api-id>.execute-api.<region>.amazonaws.com/dev/hello \
-H "Authorization: valid-token"
Cognito User Pool:

Authenticate a user via Cognito (get an ID token or access token).
Call the API with the token:
php
Copy code
curl -X GET https://<api-id>.execute-api.<region>.amazonaws.com/dev/hello \
-H "Authorization: <JWT>"

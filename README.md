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
**Copy code
exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};
Save the function.**

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

**IV)Deploy the API:**
1)Click Actions > Deploy API.
2)Create a new stage (e.g., dev) and click Deploy.
Copy the Invoke URL of the API.

**Step-by-Step Instructions: Setting up Cognito Authorizer**
1) Create a Cognito User Pool
Go to AWS Management Console and search for Cognito.
2)Click on “Create a User Pool”.

**Define Pool Settings:**

1)Provide a name for the User Pool (e.g., MyUserPool).
2)Click Step through settings.
3)Configure Sign-in Options:
4)Choose how users will sign in (e.g., email, phone number).
5)Enable email or phone number as a sign-in option.
Password Policy:

Configure the password policy as per your requirements (e.g., length, complexity).
MFA and Verification:

Choose whether you want to enable Multi-Factor Authentication (optional).
Configure verification methods (SMS or email).

**Attributes and Permissions:**

Define required attributes for the users (e.g., email, phone, etc.).
Create User Pool:

Review the settings and click Create Pool.

**V) Set Up an App Client**
1)After the User Pool is created, create an app client that your API Gateway will use.

2)Go to App Clients.
3)Click Add an App Client.
4)Provide a name (e.g., MyAppClient).
5)Disable Generate Client Secret.
6)Click Create App Client.
7)Capture the App Client ID. This will be needed when setting up the authorizer in API Gateway.
8) Go to Domain Name under App Integration.
**Create a Domain:**
2)Set a custom domain for Cognito's hosted UI (if you are using Cognito for login pages).
For example, myapp.auth.ap-south-1.amazoncognito.com.
3) Set Up Cognito Authorizer in API Gateway
Go to API Gateway in the AWS Management Console.

**Select your API**

In the API Gateway dashboard, go to the Authorizers section and click Create New Authorizer.

**Configure the Cognito Authorizer**
Name: Give your authorizer a name (e.g., MyCognitoAuth).
Type: Choose Cognito.
Cognito User Pool: Select the User Pool you created earlier (MyUserPool).
App Client ID: (Optional) Enter the App Client ID from your App Client (from step 2).
Click Create to finalize the authorizer.

**VI) Attach Cognito Authorizer to an API Method**
In API Gateway, go to Resources under your API.
Select the method you want to secure (e.g., GET /users).
Click on Method Request.
Under Authorization, select the Cognito Authorizer (MyCognitoAuth) you created.
Save the configuration.

**VII) Deploy the API**
Once you’ve attached the authorizer, go to Actions and select Deploy API.
Choose a Stage (or create a new one, like prod or dev).
Click Deploy.
You’ll get an Invoke URL for accessing the API.
**VIII) Test the API with Cognito Authorization**
Authenticate a User with Cognito:
1) We have a way to get a access token for authenticate the api gateway for a user login

     command for cloudshell to get a access token for a API gateway
   aws cognito-idp admin-initiate-auth \
  --user-pool-id <USER_POOL_ID> \
  --client-id <APP_CLIENT_ID> \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters USERNAME=<username>,PASSWORD=<password

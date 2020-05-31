Serverless AWS app based on Lambda -> SQS chain pattern
==================

This is the skeleton of framework which allows to build and deploy serverless
apps based on `AWS Lambda => SQS => AWS Lambda => ...` pattern. 

![](https://epsagon.com/wp-content/uploads/2018/11/ezgif-2-e456cb3ebd60.jpg)

This framework is based on [a Serverless Application Framework](https://www.serverless.com/)

Quick start
----
1. [a Set up AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) for your terminal
2. Install Serverless Application Framework via npm - [a Instruction](https://www.serverless.com/framework/docs/getting-started#via-npm)
3. Deploy default app
```
make deploy
```
4. Run app and get logs (logs should contain: `Received message: test_message`)
```
make run
sleep 20 #wait 20 seconds until logs stream is created in AWS
make logs
```
5. Do changes in your lambda function and redeploy only lambda_function1 function:
```
sed -i 's/test_message/NEW_TEST_MESSAGE/g' app/lambda_function1.py
make deploy FUNC=lambda_function2
```
6. Run app again and verify that logs contains your changes (logs should contain: `Received message: NEW_TEST_MESSAGE`):
```
make run
sleep 20 #wait 20 seconds until logs stream is created in AWS
make logs
```
7. Destroy all AWS resources of your app
```
make destroy
```

Stages
----
You can work with app on specified stage (environment) ex. `dev`, `uat`, `prd` by passing ENV variable into the
`make` commands ex.:
```
ENV=dev make deploy 
ENV=uat make deploy 
ENV=prd make deploy 
```
or export `ENV` variable in your terminal and use default commands ex.
```
export ENV=dev
make deploy run
```

The default stage for the app is equal to the `USER` env var on your linux machine. 
For me it is `damian`

Building and deploying AWS resources
----
`make deploy` will build and deploy infrastructure and code as defined in [a serverless.yml](serverless.yml) file:

By default resources are deployed to the default [a stage](https://serverless-stack.com/chapters/stages-in-serverless-framework.html) based on your linux
username ex. for me it is `damian`. Thanks to that multiple users can deploy to
separate AWS resources to avoid resources conflicts.

After triggering the above command following resources will be created in your
AWS account:
 - `damian-myapp-lambda_function2`
 - `damian-myapp-lambda_function1`
 - `damian-myapp-sqs-lambda_function1`

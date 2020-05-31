Serverless AWS app using 'Lambda -> SQS chain' pattern
==================

This is the skeleton of framework which allows to build and deploy serverless
apps using chain of `AWS Lambda => SQS => AWS Lambda => ...` pattern. 

![](https://epsagon.com/wp-content/uploads/2018/11/ezgif-2-e456cb3ebd60.jpg)

This framework is based on [a Serverless Application Framework](https://www.serverless.com/)

Requirements
----
- [**Set up AWS credentials**](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) for your terminal
- **Install Serverless Application Framework** via npm - [Instruction](https://www.serverless.com/framework/docs/getting-started#via-npm)

Quick start
----
1. **Deploy default app**
```
make deploy
```
2. **Run app and get logs** (logs should contain: `Received message: test_message`)
```
make run
sleep 20 #wait 20 seconds until logs stream is created in AWS
make logs
```
3. **Do changes** in your lambda function **and redeploy** only lambda_function1 function:
```
sed -i 's/test_message/NEW_TEST_MESSAGE/g' app/lambda_function1.py
make deploy FUNC=lambda_function2
```
4. **Run app again and verify that logs** contains your changes (logs should contain: `Received message: NEW_TEST_MESSAGE`):
```
make run
sleep 20 #wait 20 seconds until logs stream is created in AWS
make logs
```
5. **Destroy app** - delete all AWS resources of your app
```
make destroy
```

Stages / Environments
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
`make deploy` will build and deploy infrastructure and code as defined in [serverless.yml](serverless.yml) file:

By default resources are deployed to the default [stage](https://serverless-stack.com/chapters/stages-in-serverless-framework.html) (environment) based on your linux
username ex. for me it is `damian`. Thanks to that multiple users can deploy to
separate AWS resources to avoid resources conflicts.

After triggering the above command following resources will be created in your
AWS account:
 - AWS Lambda: `damian-myapp-lambda_function2`
 - AWS Lambda: `damian-myapp-lambda_function1`
 - AWS SQS queue: `damian-myapp-sqs-lambda_function1`

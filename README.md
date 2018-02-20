# nbconvert-service
A very light API wrapper around nbconvert

## Deploying

The `deploy.sh` script will prepare the lambda function, upload it to S3, and
deploy the service as a Cloudformation stack. After configuring AWS
credentials, you can run it with

```
./deploy.sh <bucket_name> <service_name>
```

where `bucket_name` is the name of the existing S3 bucket where the lambda
deployment package will be uploaded, and `service_name` is the name of the
stack that will be created.

Once that's done, there will be an API in your AWS account called
`<service-name>`-rest-api. You can deploy that API using the instructions
[here](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api-with-console.html).

## Using

One the API is deployed, you can make requests to it. Here's an example using
httpie:

```
http POST <stage_url>/notebook metadata:='{"doi": "whatever"}' files:=@payload.json
```

where `payload.json` contains a JSON object like this:

```
{
  "my_notebook.ipynb": "<stringified notebook json>",
  "my_other_notebook.ipynb": "<stringified notebook json>
}
```

The API response will have a `files` entry with the names of the submitted `ipynb`
files and the HTML produced by `nbconvert`.

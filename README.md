# kibana-aws-container
Kibana docker container that supports communicating signed requests to AWS ElasticSearch

In your kibana.yml add your own config values to communicate with the AWS ES endpoints:

```
# The Elasticsearch instance to use for all your queries.
elasticsearch_url: "https://search-prefix.us-east-1.es.amazonaws.com"

# For AWS Hosted ElasticSearch
transport: "AWS"
region: "us-east-1"
```

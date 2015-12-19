# kibana-aws-container
Kibana docker container that supports communicating signed requests to AWS ElasticSearch

To connet the container to your AWS ElasticSearch search cluster, set either of the environmental variables:
* ELASTICSEARCH_URL
* ELASTICSEARCH_PORT_9200_TCP

to a url, for example, of: "https://search-prefix.us-east-1.es.amazonaws.com"

# AWS ElasticSearch service integration

For quicker integration with your existing AWS VPC and the AWS ElasticSearch service, the following environmental variables can be specified while omitting ELASTICSEARCH_URL and ELASTICSEARCH_PORT_9200_TCP:

* ES_CLUSTER
* ES_CLUSTER_REGION

If you define both, the container will query the AWS CLI for the search cluster by name (ES_CLUSTER) in the region (ES_CLUSTER_REGION) and populate ELASTICSEARCH_URL with the hostname discovered.

If using the AWS discovery of the search cluster hostname, you will need to ensure the container has the IAM policy permissions to execute 'es:DescribeElasticsearchDomain' for the current account for the region specified in ES_CLUSTER_REGION.

# Extending the container

In your kibana.yml add your own config values to communicate with the AWS ES endpoints:

```
# The Elasticsearch instance to use for all your queries.
elasticsearch_url: "https://search-prefix.us-east-1.es.amazonaws.com"

# For AWS Hosted ElasticSearch
transport: "AWS"
region: "us-east-1"
```

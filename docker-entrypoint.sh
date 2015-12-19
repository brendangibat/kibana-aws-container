#!/bin/bash

set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
	set -- kibana "$@"
fi

if [ -z "$ELASTICSEARCH_URL" ] [ -z "$ELASTICSEARCH_PORT_9200_TCP" ] && \
	[ -n "$ES_CLUSTER" ] && [ -n "$ES_CLUSTER_REGION" ]; then
    export ELASTICSEARCH_HOST=$(aws es describe-elasticsearch-domain --region $ES_CLUSTER_REGION --domain-name $ES_CLUSTER --output text --query 'DomainStatus.Endpoint')
	if [ -z "$ELASTICSEARCH_HOST" ]; then
		echo >&2 'warning: could not find the es cluster for the region given'
		echo >&2
		exit 1
	fi

	export ELASTICSEARCH_URL="https://$ELASTICSEARCH_HOST"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
		: ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
		sed -ri "s!^(elasticsearch_url:).*!\1 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibana.yml
	else
		echo >&2 'warning: missing ELASTICSEARCH_PORT_9200_TCP or ELASTICSEARCH_URL'
		echo >&2 '  Did you forget to --link some-elasticsearch:elasticsearch'
		echo >&2 '  or -e ELASTICSEARCH_URL=http://some-elasticsearch:9200 ?'
		echo >&2
	fi

	if [ -z "$ES_CLUSTER" ]; then
		sed -ri "s!^\#? ?(\transport:).*!\1 \"AWS\"!" /opt/kibana/config/kibana.yml
	fi

	if [ -z "$ES_CLUSTER_REGION" ]; then
		sed -ri "s!^\#? ?(\region:).*!\1 '$ES_CLUSTER_REGION'!" /opt/kibana/config/kibana.yml
	fi

	set -- gosu kibana "$@"
fi

exec "$@"

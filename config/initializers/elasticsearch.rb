Elasticsearch::Model.client = Elasticsearch::Client.new log: true, host: "elasticsearch", retry_on_failure: true

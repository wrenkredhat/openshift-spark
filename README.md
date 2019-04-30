# OpenShift Spark

Openshift Spark is an application based on the Centos 7 image for deploying Apache Spark 2.4.2 cluster to OpenShift.

Apache Spark is a fast and general-purpose cluster computing system. It provides high-level APIs in Java, Scala, Python and R, and an optimized engine that supports general execution graphs.

[http://spark.apache.org/](http://spark.apache.org/)

OpenShift is an open source container application platform by [Red Hat](https://www.redhat.com) based on top of Docker containers and the Kubernetes container cluster manager.

[https://www.openshift.com/](https://www.openshift.com/)

## Usage

### Clone

Clone this repo to your local machine.

```
$ git clone https://github.com/bodz1lla/openshift-spark.git
$ cd openshift-spark
```

### Build

Create a build config in the OpenShift and start build the Spark image.

```
$ oc create -f openshift/build-spark-base.yaml
$ oc create imagestream spark
$ oc start-build spark-2.4.2
```
When the build has finished, please check logs and status.

```
$ oc logs -f bc/spark-2.4.2
$ oc get pod
NAME                  READY     STATUS      RESTARTS   AGE
spark-2.4.2-1-build   0/1       Completed   0          6m
```

### Deploy

#### Spark Master

Create a deployment config and start pod.

```
$ oc create -f openshift/deploy-spark-master.yaml
```

When master has started, please check logs and state "Running".

```
$ oc logs -f dc/spark-master
$ oc get pod
NAME                   READY     STATUS      RESTARTS   AGE
spark-2.4.2-1-build    0/1       Completed   0          4m
spark-master-1-mxlhj   1/1       Running     0          55s
```

Create a services with endpoints.

```
$ oc create -f openshift/service_spark_master.yaml
$ oc create -f openshift/service_spark_master_ui.yaml
```

Expose the service and create the route to allow external connections reach Spark WebUI by name.

```
$ oc expose svc/spark-master-ui --name=spark-master-ui --port=8080

```
Check route and try to access the Spark via Web browser or cURL.

```
$ oc get route spark-master-ui
$ curl -s http://${spark-master-ui}
```

> If you'd like to configure HTTPS with selfsigned certificate using TLS handshake and edge termination.
Please install "keytool" and generate a keystore, otherwise just skip this step.

> ATTENTION: Replace a var=${secret} with password.

```
$ keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass ${secret} -validity 360 -keysize 2048
# Convert to pkcs12
$ keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.p12 -srcstoretype jks -deststoretype pkcs12
```

Once key has been created, open it with OpenSSL.

```
$ openssl pkcs12 -in keystore.p12 -nodes -password pass:${secret}

```

Copy certificate with private key and save in the notes.

Edit you route and insert TLS configuration in the "spec:" collection,  behind the "port:" key.

```
oc edit route spark-master-ui

---
spec:
  ...
  port:
    targetPort: 8080
  tls:
    certificate: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    key: |
      -----BEGIN PRIVATE KEY-----
      ...
      -----END PRIVATE KEY-----
    termination: edge
    insecureEdgeTerminationPolicy: Redirect    
```

> Don't forget about YAML syntax and 2 space indent.

Check route and try to access via HTTPS.

```
$ oc get route spark-master-ui
$ curl -sk https://${spark-master-ui}
```

#### Spark Workers

##### Deploy

Create a deployment config and start pods.

> The default setup starts only 3 workers, you can change this in deploy-spark-worker.yaml. Replace a value in the key "replicas:"

```
$ oc create -f openshift/deploy-spark-workers.yaml
```

#### Spark Submit

##### Launching Applications with spark-submit

[Download Spark](https://spark.apache.org/downloads.html) release to local machine.

Check provider global firewall settings and allow TCP connection to the port 30077.  

> Current project runs with Spark version 2.4.2.

> It’s important that the Spark version running on your driver, master, and worker pods all match.

Try to run Python application on a Spark Cluster.

```
cd spark-2.4.2-bin-hadoop2.7

./bin/spark-submit \
  --master spark://176.9.28.34:30077 --name myapp  \
  ${PWD}/examples/src/main/python/pi.py 10

```

If you see successfully created connection to the cluster and running application in Spark UI, means you are done with setup.

Hope you enjoyed the setup and ready to launch your application!

## Contributing

1. Fork it (https://github.com/bodz1lla/openshift-spark/fork)
2. Create your feature branch (git checkout -b feature/foobar)
3. Commit your changes (git commit -am 'Add some foobar')
4. Push to the branch (git push origin feature/foobar)
5. Create a new Pull Request

>Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Authors

* [Bogdan Denysiuk](https://github.com/bodz1lla)

* [Wolfgang Renk](https://github.com/wrenkredhat)

## License

## Acknowledgments

* [The Apache Software Foundation](https://github.com/apache) - Apache Spark
* [Thomas Orozco](https://github.com/krallin) - init for containers [tini](https://github.com/krallin/tini)
* Veer Muchandi - video explanation - [OpenShift: Using SSL](https://www.youtube.com/watch?v=rpT5qwcL3bE)

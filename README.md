# OpenShift Spark

Openshift Spark is container based on the Centos 7 image for deploying Spark 2.4.2 cluster to OpenShift.

Apache Spark is a fast and general-purpose cluster computing system. It provides high-level APIs in Java, Scala, Python and R, and an optimized engine that supports general execution graphs.

[http://spark.apache.org/](http://spark.apache.org/)

OpenShift is an open source container application platform by [Red Hat](https://www.redhat.com) based on top of Docker containers and the Kubernetes container cluster manager.

[https://www.openshift.com/](https://www.openshift.com/)

## Usage

### Build

Create a build config in the OpenShift and start build of Spark image.

```
$ git clone https://github.com/bodz1lla/openshift-spark.git
$ cd openshift-spark
$ oc create -f build-spark-base.yaml
$ oc create imagestream spark
$ oc start-build spark-2.4.2
```
When the build has started, please check logs and status.

```
$ oc logs -f bc/spark-2.4.2
$ oc get pod
NAME                  READY     STATUS      RESTARTS   AGE
spark-2.4.2-1-build   0/1       Completed   0          6m
```

### Deploy

#### Spark Master

Create a deployment config.

```
$ oc create -f deploy-spark-master.yaml
```

When master has started, please check logs and state.

```
$ oc logs -f dc/spark-master
```

#### Spark Workers

## Contributing

1. Fork it (https://github.com/bodz1lla/openshift-spark/fork)
2. Create your feature branch (git checkout -b feature/foobar)
3. Commit your changes (git commit -am 'Add some foobar')
4. Push to the branch (git push origin feature/foobar)
5. Create a new Pull Request

>Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
>
>Please make sure to update tests as appropriate.

## Authors

## License

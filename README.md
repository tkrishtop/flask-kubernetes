# Flask application + Kubernetes deployment

Hi, thank you for being here!

Here I'm using the images built [here](https://github.com/tkrishtop/flask-scheduler):
Flask scheduler + Grafana + Prometheus, and compare two ways of 
deployment on local Vagrant VM: docker-compose vs kubernetes.

#### docker-compose

```shell
# run VM
vagrant up
vagrant ssh

# run all services
cd scheduler
docker-compose up -d
```

Please check [this readme](https://github.com/tkrishtop/flask-scheduler/blob/master/README.md)
to get which services will be available.

#### Kubernetes

minikube, kubectl, and kompose are already pre-installed on VM.
Let's go directly to the deployment (for the moment only for the Flask scheduler):

```shell
# run VM
vagrant up
vagrant ssh

# start minikube (beware of required RAM: 2G)
vagrant@vagrant:~/scheduler$ minikube start

# create deployment and service for Flask
vagrant@vagrant:~/scheduler$ kubectl apply -f scheduler-deployment.yaml,scheduler-service.yaml

# check that the service is well created 
vagrant@vagrant:~/scheduler$ kubectl get svc scheduler
NAME        TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
scheduler   NodePort   10.107.236.230   <none>        5555:30555/TCP   10s

# get an url to the service
vagrant@vagrant:~/scheduler$ minikube service --url scheduler
http://192.***.**.*:30555

# home endpoint
vagrant@vagrant:~/scheduler$ curl http://192.***.**.*:30555/
Hi there!

# ok endpoint
vagrant@vagrant:~/scheduler$ curl http://192.***.**.*:30555/ok/
OK

# ko endpoint
vagrant@vagrant:~/scheduler$ curl http://192.***.**.*:30555/ko/
Test error : 501 Not Implemented: The server does not support the action requested by the browser.

# metrics endpoint
vagrant@vagrant:~/scheduler$ curl http://192.***.**.*:30555/metrics
# HELP scheduler_request_count_total Scheduler request count
# TYPE scheduler_request_count_total counter
scheduler_request_count_total{app_name="scheduler",endpoint="/ok/",http_status="204",method="GET"} 3.0
scheduler_request_count_total{app_name="scheduler",endpoint="/",http_status="200",method="GET"} 2.0
scheduler_request_count_total{app_name="scheduler",endpoint="/ko/",http_status="504",method="GET"} 1.0
scheduler_request_count_total{app_name="scheduler",endpoint="/ok/",http_status="202",method="GET"} 2.0
scheduler_request_count_total{app_name="scheduler",endpoint="/ok/",http_status="201",method="GET"} 2.0
scheduler_request_count_total{app_name="scheduler",endpoint="/ko/",http_status="502",method="GET"} 3.0
scheduler_request_count_total{app_name="scheduler",endpoint="/ko/",http_status="503",method="GET"} 1.0
```


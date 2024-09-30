
# Create the pod with multi container 
kubectl create -f multi-container-pods.yml

# Create the pod single container
kubectl create -f single-container-pod.yml

# Check the nodes details in pods
kubectl get pod
kubectl describe pod <pod_name>

# Check the node where the pods are running and get the IP address of the worker nodes to SSH
kubectl get nodes -o yaml

ssh <IP address of the worker node>

# Now execute the below commands step by step


## Check the Linux NAMESPACES in the nodes of k8s cluster
lsns -t pid

#Check the output, here you can see the containers running inside the specific nodes with specific "pid"

# To check the Network namespaces these containers belongs to 
ip netns identify <pid of the container>

# You will get output which have network plugin prefix( something like - "cni-80h8f-89d78d-09c0ff-8k4ks9f" if CNI is the Network Plugin installed or it can be anyt NWT PlUGIN)

# Now check the IP interface running in the nodes

ip add 

# Find the Virtual Interface (veth)

ip add | grep -A1 veth

# NOw again list the Linux namespace with pid

lsns -t pid

# Now find the namespae of the containers running in the node 

for i in 2048 2068; do ip netns identify $i; done

# The above command will list the network namespace id with network plugin prefix, if two container are running inside same pod then there namespace id aill be same.

'cni-80h8f-89d78d-09c0ff-8k4ks9f'
'cni-80h8f-89d78d-09c0ff-8k4ks9f'

# To find the network configuration of a particluar Network Namespace

ip netns exec cni-80h8f-89d78d-09c0ff-8k4ks9f ip add

# It will output all the details related to network config of this Network Namespace where POD is running, somethiing like below

 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0d:3a:a0:dd:b6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.237/16 metric 100 brd 10.0.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::20d:3aff:fea0:ddb6/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:5a:ce:0f:2d brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever


# Now Let's see how Shared Configuration works in same node for two different pods

## Logout from the Worker node and comeback to ControlPlane node

# Use below command to get the List of interfaces for the pods

kubectl exec <POD_NAME> -c <CONTAINER_NAME> -- ip add

# In the output keep remember the IP address

# Now repeat the same step for other pod 

kubectl exec <POD_NAME> -C <CONTAINER_NAME> -- ip add

# Now check the output, you notice that the IP address  and other details are same as above POD , As two pods have same IP address, Mac Address and other network configs 
#you can use "localhost " to connect to the nginx container running inside same pod

kubectl exec <POD_NAME> -c <CONTAINER_NAME> -- curl -s localhost:80 -vvv


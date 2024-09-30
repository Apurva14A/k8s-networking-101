
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




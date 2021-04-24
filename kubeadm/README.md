# kubeadm 으로 k8s 클러스터 구성하기
## Kubeadm ?
kubeadm은 kubenetes Cluster를 빠르게 구성하도록 만들어진 도구이다. 

Kubeadm을 사용하여 k8s 클러스터를 구성하는 과정에 대해서 알아보도록 할 예정이다.

<br/>
<br/>

### 아래 링크는 Kubeadm 설치하는 공식 문서이다.

kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/_print/#pg-4c656c5eda3e1c06ad1aedebdc04a211


# 1. 시작하기전 구성...
 

* 권장 사양 : CPU 2코어 , RAM 2GB 이상

 

 

 

* kubenetes 구성 요소가 사용하는 포트에 대해 방화벽 오픈

 

* 마스터 노드
    ```
    sudo firewall-cmd --add-port 6443/tcp --permanent 
    sudo firewall-cmd --add-port 2379/tcp --permanent 
    sudo firewall-cmd --add-port 2380/tcp --permanent 
    sudo firewall-cmd --add-port 10250/tcp --permanent
    sudo firewall-cmd --add-port 10251/tcp --permanent
    sudo firewall-cmd --add-port 10252/tcp --permanent
    sudo firewall-cmd --reload
    ```

*  워커 노드
   ```
    sudo firewall-cmd --add-port 10250/tcp --permanent
    sudo firewall-cmd --add-port 30000-32767/tcp --permanent
    sudo firewall-cmd --reload
    ```
 

 

 

* Swap 메모리 사용하지 않음
    ```
    swapoff -a   # Swap기능 끔
    ```
 

* iptables 설정
    ```
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    

    sudo sysctl --
    ```
 

* SELinux 해제
    ```
    컨테이너가 Pod 네트워크의 host filesystem 액세스 할 수 있도록 하기위해 SELinux 해제

    sudo setenforce 0
    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
    ```

* 컨테이너 런타임 (도커) 설치
    ```

    도커 설치하는 방법은 공식 문서를 참고 !

    https://docs.docker.com/engine/install/centos/
    ```
# 2. Kubeadm, Kubectl, Kubelet 설치하기
 
## 1. repo 업데이트
    ```
    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    exclude=kubelet kubeadm kubectl
    EOF
    ``` 

 

## 2. kubeadm, kubectl, kubelet 

    sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  systemctl enable --now kubelet


## 3. 설치 확인
```
$ kubeadm version

$ kubectl version
```
## 4. 마스터 노드 구성
- --apiserver-advertise-address= 다른 노드가 마스터 노드에 접근할 수 있도록 마스터 노드의 ip주소를 명시한다.

- --pod-network-cidr= 쿠버네티스가 사용할 컨테이너의 네트워크 대역을 지정한다.
```
kubeadm init \
    --apiserver-advertise-address=10.0.0.0 \
    —-pod-network-cidr=192.168.0.0/16
 ```

위의 명령어를 실행시키면 config 파일 설정해주는 명령어가 출력된다.

그대로 복사해서 따라해주면 된다.
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## 4. 워커 노드 - 클러스터 Join
kubeadm init 했을때 맨 마지막에 출력되는 결과이다. 복사해서 워커노드에 붙여넣어 주자

워커노드가 클러스터에 join 하기 위한 명령어를 제공한다.
```
kubeadm join 10.0.0.0:6443 --token o0zezq.d3a298ky1xqdyz15 \
    --discovery-token-ca-cert-hash sha256:81089ceaa64bdda339043ee5321667ddb5c948e5c4f42dcbde3c33fbdcbc98c1
 ```

마스터 노드에서 kubectl get no 명령어로 워커노드가 join 됐는지 확인
```
kubectl get nodes

NAME              STATUS     ROLES    AGE     VERSION
ip-10-0-0-10      NotReady   master   103s    v1.21.0
ip-10-0-0-20      NotReady   <none>   3m15s   v1.21.0
 ```

## 5. 네트워크 플러그인 설치
 

아래와 같은 명령어를 실행시키면 아마도 coredns가 pending 상태로 나올것이다.
```
kubectl get po -n kube-system
```
그 이유는 Coredns가 정상적으로 작동하려면 네트워크 플러그인을 설치해주어야 하기 떄문이다.

네트워크 플러그인은 Calico, Flannel 등 여러가지가 있지만 여기서는 Calico를 설치해주도록 한다.

 

다음과 같은 명령어를 실행시키자
```
kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
 ```

## 6. 클러스터 구성 확인
아래의 명령어를 실행시켰을때 전부다 Running 상태인것 확인하기.
```
kubectl get po -n kube-system
 ```

아래의 명령어를 실행시켰을때 워커노드가 제대로 클러스터에 Join 됐는지 확인하기.
```
kubectl get no
 ```
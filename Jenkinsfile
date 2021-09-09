pipeline {
    environment {
        HARBOR_URL = "10.10.10.149:32002"
        CI_PROJECT_PATH = "samsung"
        APP_NAME = "samsung"
    }
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: gradle
    command:
    - sleep
    args:
    - 99d
    image: 10.10.10.149:32002/library/gradle:7.1.1
  - name: kaniko
    command:
    - sleep
    args:
    - 99d
    image: 10.10.10.149:32002/library/kaniko-project/executor:debug
    volumeMounts:
    - name: cacrt
      mountPath: /kaniko/ssl/certs/
    - name: dockerconfigjson
      mountPath: /kaniko/.docker/
  - name: helm
    command:
    - sleep
    args:
    - 99d
    image: 10.10.10.149:32002/library/alpine/helm:latest
  volumes:
  - name: cacrt
    secret:
      secretName: registry-cert
      items:
      - key: additional-ca-cert-bundle.crt
        path: "additional-ca-cert-bundle.crt"
  - name: dockerconfigjson
    secret:
      secretName: registry-cert
      items:
      - key: config.json
        path: "config.json"
  imagePullSecrets:
  - name: harbor-cred
'''
        }
    }
    stages {
        stage('source build') {
            steps {
                container('gradle') {
                    sh 'echo "source build"'
                }
            }
        }
        stage('image build') {
            steps {
                container('kaniko') {
                    sh '/kaniko/executor --context ./ --dockerfile ./dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:$BUILD_TAG'
                }
            }
        }
        stage('deploy') {
            steps {
                container('helm') {
                    sh 'helm upgrade --install --set image.tag=${BUILD_TAG} -n $APP_NAME --create-namespace $APP_NAME ./helm-deploy/helm'
                }
            }
        }
    }
}


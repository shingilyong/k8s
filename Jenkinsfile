pipeline {
  agent any
  stages {
    stage('prepare') {
      parallel {
        stage('prepare') {
          steps {
            sh '''ls -la
'''
          }
        }

        stage('prepare1') {
          steps {
            sh 'sh \'echo > 123\''
          }
        }

      }
    }

    stage('') {
      steps {
        withKubeConfig()
      }
    }

  }
}
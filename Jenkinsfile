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
            sh 'echo \'123\''
          }
        }

      }
    }

  }
}
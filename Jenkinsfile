pipeline {
    agent any

    stages {
        stage('Maven Build') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true verify'
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus',
                                                  usernameVariable: 'NEXUS_USER',
                                                  passwordVariable: 'NEXUS_PASS')]) {
                    sh """
                            mvn deploy -DskipTests \
                            -DaltDeploymentRepository=nexus::default::http://192.168.1.2:8081/repository/jenkins-springpetclinic/ \
                            -Dusername=$NEXUS_USER \
                            -Dpassword=$NEXUS_PASS
                    """
                }
            }
        }

        stage('Docker Compose Down') {
            steps {
                sh 'docker compose down -v || true'
            }
        }

        stage('Docker Compose Up') {
            steps {
                sh 'docker compose up -d --build'
            }
        }

        stage('Verify Containers') {
            steps {
                sh 'docker ps'
            }
        }
    }
}

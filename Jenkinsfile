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
                        mvn deploy:deploy-file \
                          -Durl=http://localhost:8081/repository/jenkins-springpetclinic/ \
                          -DrepositoryId=nexus \
                          -Dfile=target/*.jar \
                          -DgroupId=org.springframework.samples.petclinic \
                          -DartifactId=spring-petclinic \
                          -Dversion=1.0.0 \
                          -Dpackaging=jar \
                          -DgeneratePom=true \
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

pipeline {
    agent {
        docker {
            image 'my-jenkins-agent:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    tools {
        maven 'maven-3.9.11'
    }
    stages {
        stage('Build & SonarQube Analysis') {
            steps {
                sh '''
                    mvn clean package -DskipTests verify sonar:sonar \
                      -Dsonar.projectKey=spring-petclinic \
                      -Dsonar.projectName="spring-petclinic" \
                      -Dsonar.host.url=http://localhost:9000 \
                      -Dsonar.token=sqp_157395511538db3b0b1fd36bf1ee0068ea9ef5e6
                '''
            }
        }
        stage('Docker Compose Up') {
            steps {
                sh '''
                    docker-compose down || true
                    docker-compose up -d --build
                '''
            }
        }
    }
}

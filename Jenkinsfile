pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'spring-petclinic'
        SONAR_PROJECT_NAME = 'spring-petclinic'
        SONAR_HOST_URL    = 'http://192.168.1.2:9000'
        SONAR_TOKEN       = 'sqp_636fa6800249dd63abfa9c05a2f712ef07e4d870'
    }

    stages {
        stage('Maven Build & SonarQube Analysis') {
            steps {
                sh """
                    mvn clean package -Dmaven.test.skip=true verify \
                    sonar:sonar \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.projectName="${SONAR_PROJECT_NAME}" \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.token=${SONAR_TOKEN}
                """
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

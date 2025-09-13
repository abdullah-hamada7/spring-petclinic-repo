pipeline {
    agent {
        docker {
            image 'maven:3.9.9-eclipse-temurin-17'
            args '--network spring-petclinic-repo_default' 
        }
    }

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
                        mkdir -p $HOME/.m2
                        cat > $HOME/.m2/settings.xml <<EOF  
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>$NEXUS_USER</username>
      <password>$NEXUS_PASS</password>
    </server>
  </servers>
</settings>
EOF
                        mvn deploy -DskipTests
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

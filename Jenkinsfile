pipeline {
    agent {
        docker {
            image 'my-jenkins-agent'
            args '''
                --network jenkins-net \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -u root
            '''
        }
    }

    environment {
        MAVEN_OPTS = '-Dmaven.test.skip=true'
    }

    stages {
        stage('Maven Build') {
            steps {
                sh 'mvn clean package verify'
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus',
                                                  usernameVariable: 'NEXUS_USER',
                                                  passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
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
                    '''
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

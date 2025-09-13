pipeline {
    agent any

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
    }
}

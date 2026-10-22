pipeline {
  agent any
  options {
    disableConcurrentBuilds()
  }
  triggers {
    pollSCM('H/5 * * * *')
  }
  stages {
    stage('Desplegar') {
      steps {
        // Credencial tipo "Secret file" con el contenido del .env
        withCredentials([file(credentialsId: 'fleetier-env', variable: 'ENV_FILE')]) {
          sh 'docker compose --env-file "$ENV_FILE" up -d --wait db'
          sh 'docker compose --env-file "$ENV_FILE" run --rm --build migrar'
        }
      }
    }
  }
}

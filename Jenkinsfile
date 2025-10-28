pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/DenysQA/Racetrack-mobile.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                echo Building Scratch game...
                npm install
                npx turbowarp-packager game.sb3 --target android --output build.apk
                '''
            }
        }

    }
    post {
        success {
            archiveArtifacts artifacts: '**/build.apk', fingerprint: true
            echo "✅ APK archived successfully!"
        }

        failure {
            echo '❌ Build failed!'
        }
    }
}

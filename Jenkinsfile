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
                sh 'echo Building Scratch game...'
            }
        }
    }

    post {
        success {
            echo '✅ Build completed successfully!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}

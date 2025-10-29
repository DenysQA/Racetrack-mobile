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
                # додаємо Homebrew до PATH, щоб знайти npm
                export PATH=/usr/local/bin:$PATH
                echo "PATH is $PATH"
                which node || echo "node not found"
                which npm || echo "npm not found"
                npm install 

                echo "📦 Installing dependencies..."
                npm install

                echo "🚀 Building Scratch game..."
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

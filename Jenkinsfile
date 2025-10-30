pipeline {
    agent any

    tools {
        nodejs "Node18"
    }

    environment {
        SB3_URL = "https://raw.githubusercontent.com/DenysQA/Racetrack-mobile/main/Racetrack_mobile_v0.0.sb3"
        SB3_FILE = "Racetrack_mobile_v0.0.sb3"
        BUILD_OUTPUT = "build.apk"
    }

    stages {

        stage('Checkout') {
            steps {
                sshagent(['github_ssh']) {
                    git branch: 'main',
                        url: 'git@github.com:DenysQA/Racetrack-mobile.git'
                }
            }
        }

        stage('Install System Dependencies') {
            steps {
                sh '''
                    echo "⚙️ Installing Java (required for Android build)..."
                    if ! command -v java >/dev/null 2>&1; then
                        brew install openjdk@17 || sudo apt-get update && sudo apt-get install -y openjdk-17-jdk
                    fi

                    java -version
                '''
            }
        }

        stage('Setup Node and Packager') {
            steps {
                sh '''
                    echo "🧩 Checking Node.js and npm..."
                    which node
                    node -v
                    npm -v

                    echo "📦 Installing TurboWarp Packager CLI..."
                    npm install -g @turbowarp/packager-cli
                '''
            }
        }

        stage('Download Scratch Game') {
            steps {
                sh '''
                    echo "🎮 Downloading Scratch project..."
                    curl -L -o ${SB3_FILE} ${SB3_URL}

                    if [ ! -f "${SB3_FILE}" ]; then
                        echo "❌ Scratch file not found after download!"
                        exit 1
                    fi

                    echo "✅ Scratch project downloaded successfully!"
                    ls -lh ${SB3_FILE}
                '''
            }
        }

        stage('Build Android APK') {
            steps {
                sh '''
                    echo "🚀 Building Android APK using TurboWarp Packager CLI..."
                    twpackager ${SB3_FILE} --target android --output ${BUILD_OUTPUT} --no-chromium-sandbox

                    if [ ! -f "${BUILD_OUTPUT}" ]; then
                        echo "❌ Build failed — APK not found!"
                        exit 1
                    fi

                    echo "✅ Build completed successfully!"
                    ls -lh ${BUILD_OUTPUT}
                '''
            }
        }
    }

    post {
        success {
            echo "🎉 Build pipeline completed successfully!"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}

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

        stage('Download Scratch Game') {
            steps {
                sh '''
                    echo "🎮 Downloading Scratch project..."
                    curl -L -o ${SB3_FILE} ${SB3_URL}

                    if [ ! -f "${SB3_FILE}" ]; then
                        echo "❌ Scratch file not found after download!"
                        exit 1
                    fi

                    echo "✅ Scratch project downloaded successfully:"
                    ls -lh ${SB3_FILE}
                '''
            }
        }

    stage('Build Android APK') {
        steps {
            sh '''
                echo "🚀 Building Scratch game to APK using TurboWarp API..."
                
                # Виконуємо запит і перевіряємо тип відповіді
                RESPONSE=$(curl -s -w "%{content_type}" -X POST \
                    -o build.apk \
                    -F "project=@${SB3_FILE}" \
                    https://packager.turbowarp.org/)

                if [[ "$RESPONSE" == "text/plain"* ]]; then
                    echo "⚠️ TurboWarp returned a text response instead of APK:"
                    cat build.apk
                    rm build.apk
                    exit 1
                fi

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

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

                RESPONSE=$(curl -s -w "%{content_type}" -X POST \
                    -o build.apk \
                    -F "project=@Racetrack_mobile_v0.0.sb3" \
                    -F "packager=android" \
                    https://packager.turbowarp.org/)

                if [[ "$RESPONSE" == "text/plain"* ]]; then
                    echo "⚠️ TurboWarp returned text instead of APK:"
                    cat build.apk
                    echo "🔄 Trying to build web version instead..."
                    
                    curl -s -L -X POST \
                        -o build.zip \
                        -F "project=@Racetrack_mobile_v0.0.sb3" \
                        -F "packager=zip" \
                        https://packager.turbowarp.org/

                    if [ -f build.zip ]; then
                        echo "✅ Web version built successfully (build.zip)"
                        ls -lh build.zip
                    else
                        echo "❌ Both Android and Web builds failed!"
                        exit 1
                    fi
                else
                    echo "✅ Android APK built successfully!"
                    ls -lh build.apk
                fi
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

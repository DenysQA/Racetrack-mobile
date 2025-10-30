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
                echo "🚀 Starting app on custom port..."
                npx serve . -l 8090 &
                SERVER_PID=$!
                sleep 5

                echo "🧩 Checking Node.js and npm..."
                node -v
                npm -v

                echo "📦 Installing TurboWarp Packager (local clone)..."
                rm -rf packager
                git clone https://github.com/TurboWarp/packager.git
                cd packager
                npm install
                npm run build
                cd ..

                echo "🎮 Building HTML from SB3 using TurboWarp remote CLI..."
                npx github:turbowarp/packager-cli ${SB3_FILE} --html www/index.html || {
                echo "❌ Failed to build HTML from SB3"
                exit 1
                }


                echo "✅ HTML build complete!"
                kill $SERVER_PID || true
                '''
            }
        }
        stage('Download Scratch Game') {
            steps {
                sh '''
                    echo "🎮 Downloading Scratch project..."
                    curl -L -o ${SB3_FILE} ${SB3_URL}
                    echo "🎮 Building HTML from SB3 using remote TurboWarp CLI..."
                    npx github:turbowarp/packager-cli ${SB3_FILE} --html www/index.html || {
                    echo "❌ Failed to build HTML from SB3"
                    exit 1
                    }
                    echo "✅ Scratch project downloaded successfully!"
                    ls -lh ${SB3_FILE}
                '''
            }
        }

        stage('Build Android APK (Local TurboWarp)') {
            steps {
                echo '🚀 Starting local TurboWarp Packager build...'

                // Переконуємось, що Node.js встановлено
                sh '''
                echo '🧩 Checking Node.js...'
                node -v
                npm -v
                '''

                // Клонуємо TurboWarp Packager, якщо ще не завантажено
                sh '''
                if [ ! -d "turbowarp-packager" ]; then
                    echo '📥 Cloning TurboWarp Packager repo...'
                    git clone https://github.com/TurboWarp/packager.git turbowarp-packager
                fi
                '''

                // Встановлюємо залежності
                sh '''
                cd turbowarp-packager
                echo '📦 Installing dependencies...'
                npm install
                npm run build
                '''

                // Запускаємо локальний сервер у бекграунді
                sh '''
                echo '🌐 Starting local TurboWarp server...'
                cd turbowarp-packager
                nohup npm start > ../turbowarp.log 2>&1 &
                sleep 5
                '''

                // Виконуємо збірку .sb3 → APK через локальний сервер
                sh '''
                echo '⚙️ Building Android APK via local TurboWarp server...'
                npm run build:html
                npm run build:android
                '''

                // Перевіряємо результат
                sh '''
                echo '✅ Build complete! Resulting APK:'
                ls -lh build.apk
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
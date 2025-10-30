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
                    echo "⚙️ Checking Java (required for Android build)..."
                    if ! command -v java >/dev/null 2>&1; then
                        echo "Installing Java..."
                        if command -v apt-get >/dev/null 2>&1; then
                            sudo apt-get update && sudo apt-get install -y openjdk-17-jdk
                        elif command -v brew >/dev/null 2>&1; then
                            brew install openjdk@17
                        fi
                    fi
                    java -version
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

        stage('Build HTML from SB3') {
            steps {
                sh '''
                    echo "📦 Installing TurboWarp Packager..."
                    rm -rf packager
                    git clone https://github.com/TurboWarp/packager.git
                    cd packager
                    npm install
                    npm run build
                    cd ..

                    echo "🎮 Building HTML from SB3 using TurboWarp CLI..."
                    npx github:turbowarp/packager-cli ${SB3_FILE} --html www/index.html || {
                        echo "❌ Failed to build HTML from SB3"
                        exit 1
                    }

                    echo "✅ HTML build complete!"
                '''
            }
        }

        stage('Build Android APK (Local TurboWarp)') {
            steps {
                sh '''
                    echo "🚀 Building Android APK via local TurboWarp packager..."

                    if [ ! -d "packager" ]; then
                        git clone https://github.com/TurboWarp/packager.git
                        cd packager
                        npm install
                        npm run build
                        cd ..
                    fi

                    cd packager
                    echo "🌐 Starting local TurboWarp server..."
                    nohup npm start

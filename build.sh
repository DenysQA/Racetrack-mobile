#!/bin/bash
set -e

INPUT_FILE="Racetrack_mobile_v0.0.sb3"
OUTPUT_FILE="build/Racetrack_mobile_v0.0.apk"

mkdir -p build

echo "🔧 Packaging $INPUT_FILE into APK..."
turbowarp-packager
--input "$INPUT_FILE"
--type android
--app-name "Racetrack_mobile"
--app-id "com.example.racetrack"
--output "$OUTPUT_FILE"

echo "✅ Done! Created $OUTPUT_FILE"#!/bin/bash
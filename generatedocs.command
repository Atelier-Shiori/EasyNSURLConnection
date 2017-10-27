cd "$(dirname "$0")"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
jazzy \
  --objc \
  --clean \
  --author "Atelier Shiori" \
  --author_url https://ateliershiori.moe \
  --github_url https://github.com/Atelier-Shiori/EasyNSURLConnection \
  --github-file-prefix hhttps://github.com/Atelier-Shiori/EasyNSURLConnection/tree/v1.0 \
  --module-version 1.0 \
  --xcodebuild-arguments --objc,EasyNSURLConnection/EasyNSURLConnection.h,--,-x,objective-c,-isysroot,$(xcrun --show-sdk-path),-I,$(pwd) \
  --module EasyNSURLConnection \
  --root-url https://developer.ateliershiori.moe/easynsurlconnection/ \
  --output docs/
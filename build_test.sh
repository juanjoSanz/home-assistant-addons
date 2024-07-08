cd openwisp
docker build \
  --build-arg BUILD_FROM="homeassistant/aarch64-base:latest" \
  -t local/my-test-addon \
  .
FROM docker.io/minio/minio:RELEASE.2025-07-17T12-07-51Z

# Create the langfuse bucket before starting
ENTRYPOINT ["sh"]
CMD ["-c", "mkdir -p /data/langfuse && minio server --address :9000 --console-address :9001 /data"]

HEALTHCHECK --interval=1s --timeout=5s --retries=5 --start-period=1s \
  CMD mc ready local || exit 1

EXPOSE 9000 9001

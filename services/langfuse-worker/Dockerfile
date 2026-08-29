FROM docker.langfuse.com/langfuse/langfuse:4

# Langfuse worker service - port 3030
# Use the main langfuse image which has both web and worker code
# Override CMD to run the worker process
HEALTHCHECK NONE

EXPOSE 3030
ENV PORT=3030

# Run the worker process from the main image
CMD ["node", "packages/worker/dist/index.js"]

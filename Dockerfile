ARG BUILDPLATFORM

FROM --platform=$BUILDPLATFORM ubuntu:20.04 as builder

# Create a nonroot user for final image
RUN useradd -u 10001 nonroot

# Scratch can be used as the base image because the backend is compiled to include all
# its dependencies.
FROM --platform=$BUILDPLATFORM scratch as final

# Add all files from current working directory to the root of the image, i.e., copy dist directory
# layout to the root directory.
ADD . /

# Copy nonroot user
COPY --from=builder /etc/passwd /etc/passwd
USER nonroot

# The port that the application listens on.
EXPOSE 9090 8443
ENTRYPOINT ["/dashboard", "--insecure-bind-address=0.0.0.0", "--bind-address=0.0.0.0"]

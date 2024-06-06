# Use a Golang base image
FROM golang:1.17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and build dependencies
COPY go.mod ./
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the static binary
RUN CGO_ENABLED=0 GOOS=linux go build -o main -ldflags '-extldflags "-static"'

# Use a minimal base image for the final container
FROM scratch

# Copy the static binary from the builder stage
COPY --from=builder /app/main /main

# Set the entry point for the container
ENTRYPOINT ["/main"]

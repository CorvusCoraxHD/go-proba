# Start from a base Golang image
FROM golang:1.21 AS builder

# Set the current working directory inside the container
WORKDIR /app

# Copy the Go modules files
COPY go.mod ./

# Download and install dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN go build -o main .

# Start from a smaller base image
FROM gcr.io/distroless/base-debian10

# Copy the built executable from the previous stage
COPY --from=builder /app/main /

# Set the entry point for the container
ENTRYPOINT ["/main"]

# Expose the port that the application listens on
EXPOSE 8080

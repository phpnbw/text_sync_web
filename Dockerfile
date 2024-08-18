# Use Golang image to build the Go app
FROM golang:1.20-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to the workspace
COPY go.mod ./
COPY go.sum ./

# Download all Go dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go app
RUN go build -o main .

# Create a smaller image for running the application
FROM alpine:latest

WORKDIR /root/

# Copy the prebuilt binary and static files from the builder stage
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]

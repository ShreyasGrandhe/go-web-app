# -------- Stage 1: Build the Go binary --------
FROM golang:1.22-bookworm AS base

WORKDIR /app

# Download dependencies
COPY go.mod .
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build a Linux/amd64 binary called "main"
RUN GOOS=linux GOARCH=amd64 go build -o main .

# -------- Stage 2: Minimal runtime image (distroless) --------
FROM gcr.io/distroless/base-debian12

# Copy the compiled binary from the builder stage to /main
COPY --from=base /app/main /main

# Copy static files (if your app uses them)
COPY --from=base /app/static /static

EXPOSE 8080

# Run the binary
ENTRYPOINT ["/main"]


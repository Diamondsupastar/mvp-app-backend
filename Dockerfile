# Build stage
FROM swift:5.9 as build
WORKDIR /app
COPY ./Backend/Package.* ./
RUN swift package resolve
COPY ./Backend .
RUN swift build -c release

# Run stage
FROM swift:5.9-slim
WORKDIR /app
COPY --from=build /app/.build/release/App /app/App
EXPOSE 8080
ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]

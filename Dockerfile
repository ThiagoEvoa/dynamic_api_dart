# Use the official Dart image as the build environment.
FROM dart:stable AS build

# Set the working directory.
WORKDIR /app

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code.
COPY . .

# Install dart_frog_cli to build the project.
RUN dart pub add --dev dart_frog_cli

# Create the production build.
RUN dart_frog build

# Resolve dependencies in the build directory.
WORKDIR /app/build
RUN dart pub get

# Compile the server to a self-contained executable.
RUN dart compile exe bin/server.dart -o bin/server

# Use a minimal runtime image.
FROM debian:stable-slim

# Copy the executable from the build stage.
COPY --from=build /app/build/bin/server /app/bin/server

# Expose the port used by Dart Frog (default 8080).
EXPOSE 8080

# Start the server.
CMD ["/app/bin/server"]
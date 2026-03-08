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
# RUN dart pub global activate dart_frog_cli --no-executables

# Create the production build.
# RUN dart pub global run dart_frog_cli:dart_frog build

# Resolve dependencies in the build directory.
# WORKDIR /app/build
# RUN dart pub get

# Compile the server to a self-contained executable.
# RUN dart compile exe bin/server.dart -o bin/server

# Use a minimal runtime image.
# FROM debian:stable-slim

# Copy the executable from the build stage.
# COPY --from=build /app/build/bin/server /app/bin/server

# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Expose the port used by Dart Frog (default 8080).
EXPOSE 8080

# Start the server.
CMD ["/app/bin/server"]
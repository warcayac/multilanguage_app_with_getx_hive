# Multilanguage Android App with GetX and Hive

![preview](multilanguage.gif)

## Getting Started

This project does the following tasks, it:

- toggles between different languages,
- installs new languages packages from external sources, and
- offers local data persistence.

After installing new language packages the app needs to restart for the changes to take effect.

### Note
- `wnetworking` package is not ready to publish yet, it contains operations related to API, etc. You can replace `HttpReqService.getJson` with your typical `http.get` but keep in mind the return value and exceptions.

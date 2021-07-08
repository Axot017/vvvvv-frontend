FROM debian:stable-slim AS builder

RUN apt-get update 

RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3

RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /flutter -b 2.2.3

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v

WORKDIR /app

COPY ./pubspec.* ./

RUN flutter pub get

COPY ./ ./

RUN flutter pub run easy_localization:generate -f keys -S "assets/translations" -O "lib/localization" -o "locale_keys.g.dart"

RUN flutter pub run build_runner build --delete-conflicting-outputs

RUN flutter build web --release

FROM nginx:mainline

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d

COPY --from=builder /app/build/web /usr/share/nginx/html

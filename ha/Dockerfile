FROM homeassistant/home-assistant
ARG userid
ARG username
RUN useradd --no-create-home --user-group --shell /bin/bash --uid $userid $username 
# TODO: Need to prevent start until MQTT is up:
# https://docs.docker.com/compose/startup-order/
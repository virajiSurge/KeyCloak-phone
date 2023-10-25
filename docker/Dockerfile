
FROM quay.io/keycloak/keycloak:21.0.2

ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
# main provider
COPY providers/keycloak-phone-provider.jar /opt/keycloak/providers/

#resources
COPY providers/keycloak-phone-provider.resources.jar /opt/keycloak/providers/

#dummy provider
COPY providers/keycloak-sms-provider-dummy.jar /opt/keycloak/providers/


#twilio provider
COPY providers/keycloak-sms-provider-twilio.jar /opt/keycloak/providers/

RUN mkdir /opt/keycloak/certs

RUN /opt/keycloak/bin/kc.sh start-dev





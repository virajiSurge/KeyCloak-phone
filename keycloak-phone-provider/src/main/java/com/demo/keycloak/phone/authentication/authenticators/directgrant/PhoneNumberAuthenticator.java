package com.demo.keycloak.phone.authentication.authenticators.directgrant;

import com.demo.keycloak.phone.Utils;
import org.jboss.logging.Logger;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;

public class PhoneNumberAuthenticator extends BaseDirectGrantAuthenticator {

    private static final Logger logger = Logger.getLogger(PhoneNumberAuthenticator.class);

    @Override
    public boolean requiresUser() {
        return false;
    }

    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
    }

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        context.clearUser();
        getPhoneNumber(context).ifPresentOrElse(phoneNumber ->
            Utils.findUserByPhone(context.getSession(),context.getRealm(),phoneNumber)
                .ifPresentOrElse(user -> {
                    context.setUser(user);
                    context.success();
                },()->invalidCredentials(context)),() -> invalidCredentials(context));
    }
}

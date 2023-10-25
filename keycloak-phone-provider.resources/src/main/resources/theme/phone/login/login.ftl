<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password','code','phoneNumber') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">

        <#if !usernameHidden?? && supportPhone??>

            <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
            <style>
                [v-cloak] > * {
                    display: none;
                }

                [v-cloak]::before {
                    content: "loading...";
                }
            </style>
        </#if>


        <div id="vue-app">
            <div v-cloak>

                    <#if realm.password>
                    <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">

                        <#if !usernameHidden?? && supportPhone??>
                            <div class="${properties.kcFormClass!}">
                                <div class="alert-error ${properties.kcAlertClass!} pf-m-danger" v-show="errorMessage">
                                    <div class="pf-c-alert__icon">
                                        <span class="${properties.kcFeedbackErrorIcon!}"></span>
                                    </div>

                                    <span class="${properties.kcAlertTitleClass!}">{{ errorMessage }}</span>
                                </div>


                                
                            </div>

                            <input type="hidden" id="phoneActivated" name="phoneActivated" v-model="phoneActivated">
                       </#if>


                       

                        <#if !usernameHidden?? && supportPhone??>
                            <div v-if="phoneActivated">
                                <div class="${properties.kcFormGroupClass!}">
                                    <label for="phoneNumber" class="${properties.kcLabelClass!}">${msg("phoneNumber")}</label>
                                    <input tabindex="0" type="text" id="phoneNumber" name="phoneNumber" v-model="phoneNumber"
                                           aria-invalid="<#if messagesPerField.existsError('code','phoneNumber')>true</#if>"
                                           class="${properties.kcInputClass!}" autofocus/>
                                    <#if messagesPerField.existsError('code','phoneNumber')>
                                        <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                    ${kcSanitize(messagesPerField.getFirstError('phoneNumber','code'))?no_esc}
                                        </span>
                                    </#if>
                                </div>

                                <div class="${properties.kcFormGroupClass!} row">
                                    <div class="${properties.kcLabelWrapperClass!}"  style="padding: 0">
                                        <label for="code" class="${properties.kcLabelClass!}">${msg("verificationCode")}</label>
                                    </div>
                                    <div class="col-xs-8" style="padding: 0 5px 0 0">
                                        <input tabindex="0" type="text" id="code" name="code"
                                               aria-invalid="<#if messagesPerField.existsError('code','phoneNumber')>true</#if>"
                                               class="${properties.kcInputClass!}" autocomplete="off"/>

                                    </div>
                                    <div class="col-xs-4" style="padding: 0 0 0 5px">
                                        <input tabindex="0" style="height: 36px"
                                               class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                                               type="button" v-model="sendButtonText" :disabled='sendButtonText !== initSendButtonText' v-on:click="sendVerificationCode()"/>
                                    </div>
                                </div>
                            </div>
                        </#if>


                        <div id="kc-form-buttons" class="${properties.kcFormGroupClass!}">
                            <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                            <input tabindex="0" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
                        </div>

                    </form>
                    </#if>
            </div>
        </div>

        <#if !usernameHidden?? && supportPhone??>
            <script type="text/javascript">

                function req(phoneNumber) {
                    const params = {params: {phoneNumber}}
                    axios.get(window.location.origin + '/realms/${realm.name}/sms/authentication-code', params)
                        .then(res => app.disableSend(res.data.expires_in))
                        .catch(e => app.errorMessage = e.response.data.error);
                }

                var app = new Vue({
                    el: '#vue-app',
                    data: {
                        errorMessage: '',
                        freezeSendCodeSeconds: 0,
                        phoneActivated: <#if attemptedPhoneActivated??>true<#else>true</#if>,
                        phoneNumber: '${attemptedPhoneNumber!}',
                        sendButtonText: '${msg("sendVerificationCode")}',
                        initSendButtonText: '${msg("sendVerificationCode")}',
                        disableSend: function(seconds) {
                            if (seconds <= 0) {
                                app.sendButtonText = app.initSendButtonText;
                            } else {
                                const minutes = Math.floor(seconds / 60) + '';
                                const seconds_ = seconds % 60 + '';
                                app.sendButtonText = String(minutes.padStart(2, '0') + ":" + seconds_.padStart(2, '0'));
                                setTimeout(function () {
                                    app.disableSend(seconds - 1);
                                }, 1000);
                            }
                        },
                        sendVerificationCode: function() {

                            const phoneNumber = document.getElementById('phoneNumber').value.trim();
                            if (!phoneNumber) {
                                this.errorMessage = '${msg("requiredPhoneNumber")}';
                                document.getElementById('phoneNumber').focus();
                                return;
                            }
                            if (this.sendButtonText !== this.initSendButtonText) {
                                return;
                            }
                            req(phoneNumber);

                        }
                    }
                });
            </script>
        </#if>

    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <div id="kc-registration">
                    <span>${msg("noAccount")} <a tabindex="0"
                                                 href="${url.registrationUrl}">${msg("doRegister")}</a></span>
                </div>
            </div>
        </#if>
    <#elseif section = "socialProviders" >
        <#if realm.password && social.providers??>
            <div id="kc-social-providers" class="${properties.kcFormSocialAccountSectionClass!}">
                <hr/>
                <h4>${msg("identity-provider-login-label")}</h4>

                <ul class="${properties.kcFormSocialAccountListClass!} <#if social.providers?size gt 3>${properties.kcFormSocialAccountListGridClass!}</#if>">
                    <#list social.providers as p>
                        <a id="social-${p.alias}" class="${properties.kcFormSocialAccountListButtonClass!} <#if social.providers?size gt 3>${properties.kcFormSocialAccountGridItem!}</#if>"
                           type="button" href="${p.loginUrl}">
                            <#if p.iconClasses?has_content>
                                <i class="${properties.kcCommonLogoIdP!} ${p.iconClasses!}" aria-hidden="true"></i>
                                <span class="${properties.kcFormSocialAccountNameClass!} kc-social-icon-text">${p.displayName!}</span>
                            <#else>
                                <span class="${properties.kcFormSocialAccountNameClass!}">${p.displayName!}</span>
                            </#if>
                        </a>
                    </#list>
                </ul>
            </div>
        </#if>
    </#if>

</@layout.registrationLayout>
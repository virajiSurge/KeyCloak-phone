# KeyCloak-phone
Registration and login using phone

This is what this implementation is capabble of

- User registration by taking phone number as username and verification using OTP.
- User login by entering phone number and OTP verification.

Note:Twilio is used as the sms service provider, but any other provider can be used.
For demonstration purpose the otp is generated and logged in the console using the dummy module.

---

## Setup the depending containers with Docker

Refer to [install docker](https://docs.docker.com/engine/install/) to install docker 

## Setup the modules and jar files

Currently, the code is implemented to use the dummy module for sms service. If you want to change it to the twilio implementation, change the
code accordingly.

Navigate to the project root directory an run the following command.

```
mvn clean package
```

## Installation using docker

### Dockerfile

Navigate the target folder and run the docker file.

### Manually run the docker container

Navigate to the target folder and run the following command for dev mode.

```
docker run -p 8080:8080 -v ${pwd}/providers:/opt/keycloak/providers -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:22.0.3 start-dev
```
---

## Setting up the keyclok instance for user registration and user login

- The instance will be available at [http://localhost:8080](http://localhost:8080)
- Log in to the admin console using username and password as entered in the docker command.

```
Username: admin
Password: admin
```
### User registration

- Create a Test realm
- Create a clinet for this realm and obtain the cleint Id
- Set the login theme as `phone` an =d enable user registration
- Under `Authentication` > `Flows`:

+ Copy the `Registration` flow to `Registration with phone` flow through the menu button on the right of the `registration` flow

+ Replace `Registration User Creation` with `Registration Phone User Creation`

+ (Optional) Click on settings for `Registration Phone User Creation` to configure it

+ (Optional) To enable phone verification, click on `Registration with phone registration Form` >`Add` `Phone validation` if you want to verify phone.

+ (Optional) Read query parameter add to user attribute:  
  Click on `Registration with phone registration Form` > `Actions` > `Add execution` on the `Query Parameter Reader` line  
  Click on `Registration with phone registration Form` > `Actions` > `configure` add accept param name in to  

+ (Optional) Hidden password field:  
  Delete or disable `Password Validation`.

+ (Optional) if not any user profile:  
  Delete or disable `Profile Validation`

Set all added items as `Required`.

On the `Authentication` page, bind `Registration with phone` to `Registration flow` and select it to be `Required`.

Under `Realm Settings` > `Themes`
Set `Login Theme` to `phone`

Registration URL:
```
http://<domain>/realms/<realm name>/protocol/openid-connect/registrations?client_id=<client id>&response_type=code&scope=openid%20email&redirect_uri=<redirect_uri>
```

### Login by phone
Under `Authentication` > `Flows`:
+ Copy the `Browser` flow to `Browser with phone` flow
+ Replace `Username Password Form` with `Phone Username Password Form`
+ Click on the settings icon next to `Phone Username Password Form` to configure.

Under `Realm Settings` > `Themes`
Set Login Theme as `phone`

Set Bind `Browser with phone` to `Browser flow`
On the `Authentication` page, bind `Browser with phone` to `Browser flow`



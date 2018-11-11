import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.*;
import jenkins.model.*;
import hudson.security.*;
import org.jenkinsci.plugins.googlelogin.GoogleOAuth2SecurityRealm;


def instance = Jenkins.getInstance();

String clientId = '$GOOGLE_LOGIN_CLIENT_ID'
String clientSecret = '$GOOGLE_LOGIN_CLIENT_SECRET'
String domains = '$GOOGLE_LOGIN_DOMAIN'
SecurityRealm ldap_realm = new GoogleOAuth2SecurityRealm(clientId, clientSecret, domains);

instance.setAuthorizationStrategy(new hudson.security.FullControlOnceLoggedInAuthorizationStrategy())
instance.setSecurityRealm(ldap_realm)
instance.save()
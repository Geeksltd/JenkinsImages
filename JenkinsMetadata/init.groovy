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


def instance = Jenkins.getInstance()

String clientId = System.getenv("GOOGLE_LOGIN_CLIENT_ID")
String clientSecret = System.getenv("GOOGLE_LOGIN_CLIENT_SECRET")
String domain = System.getenv("GOOGLE_LOGIN_DOMAIN")
SecurityRealm ldap_realm = new GoogleOAuth2SecurityRealm(clientId, clientSecret, domain)
instance.setSecurityRealm(ldap_realm)


def strategy = new hudson.security.GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, 'authenticated')
instance.setAuthorizationStrategy(strategy)

instance.save()
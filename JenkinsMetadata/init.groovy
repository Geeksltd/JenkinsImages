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
import org.jenkinsci.plugins.permissivescriptsecurity.PermissiveWhitelist;
import org.jenkinsci.plugins.permissivescriptsecurity.PermissiveWhitelist.Mode;
import hudson.plugins.git.*;



def instance = Jenkins.getInstance()

// Set google as the authentication provider
String clientId = System.getenv("GOOGLE_LOGIN_CLIENT_ID")
String clientSecret = System.getenv("GOOGLE_LOGIN_CLIENT_SECRET")
String domain = System.getenv("GOOGLE_LOGIN_DOMAIN")
SecurityRealm ldap_realm = new GoogleOAuth2SecurityRealm(clientId, clientSecret, domain)
instance.setSecurityRealm(ldap_realm)

def strategy = new hudson.security.GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, 'Matt')
instance.setAuthorizationStrategy(strategy)

instance.save()

// Add the project job
def scm = new GitSCM(System.getenv("PROJECT_JENKINS_FILE_GIT_URL"))
scm.branches = [new BranchSpec("*/"+System.getenv("BRANCH"))];
def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")
def parent = Jenkins.instance
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, System.getenv("PROJECT"))
job.definition = flowDefinition

parent.reload()

// Disable security for running scripts.
PermissiveWhitelist.MODE = Mode.NO_SECURITY


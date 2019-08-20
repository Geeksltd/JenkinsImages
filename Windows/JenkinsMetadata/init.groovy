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
import jenkins.install.InstallState;


print "Started initialization from init.groovy"
def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

// Set up google
def env = System.getenv()

def clientId = env["GOOGLE_APP_CLIENT_ID"]
def clientSecret = env["GOOGLE_APP_SECRET"]
def domain = env["GOOGLE_ACCOUNT_DOMAIN"]

def googleRealm = new GoogleOAuth2SecurityRealm(clientId, clientSecret, domain)
instance.setSecurityRealm(googleRealm)

def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "matt@geeks.ltd.uk")
strategy.add(Jenkins.ADMINISTER, "paymon@geeks.ltd.uk")
instance.setAuthorizationStrategy(strategy)
instance.save()

// Add the project job
def scm = new GitSCM(System.getenv("PROJECT_JENKINSFILE_GIT_URL"))
scm.branches = [new BranchSpec("*/master")];
def jobFlowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, System.getenv("PROJECT_JENKINSFILE_NAME"))
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(instance, System.getenv("REPOSITORY_NAME") + "_" + System.getenv("BRANCH"))
job.definition = jobFlowDefinition

// Add the authorization sync job
def authSyncJob = new org.jenkinsci.plugins.workflow.job.WorkflowJob(instance, "Authorization sync")
def authSyncJobFlowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, System.getenv("AUTHORIZATION_SYNC_JENKINSFILE_NAME"))
authSyncJob.definition = authSyncJobFlowDefinition

parent.reload()

// Disable security for running scripts.
PermissiveWhitelist.MODE = Mode.NO_SECURITY
print "Finished initialization from init.groovy"



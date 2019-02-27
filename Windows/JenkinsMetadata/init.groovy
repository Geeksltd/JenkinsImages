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
f
// Add the admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin', System.getenv("JENKINS_ADMIN_PASSWORD"));
instance.setSecurityRealm(hudsonRealm)

def strategy = new hudson.security.GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "admin")
instance.setAuthorizationStrategy(strategy)

instance.save()

// Add the project job
def scm = new GitSCM(System.getenv("PROJECT_JENKINSFILE_GIT_URL"))
scm.branches = [new BranchSpec("*/master")];
def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, System.getenv("PROJECT_JENKINSFILE_NAME"))
def parent = Jenkins.instance
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, System.getenv("PROJECT"))
job.definition = flowDefinition

parent.reload()

// Disable security for running scripts.
PermissiveWhitelist.MODE = Mode.NO_SECURITY
print "Finished initialization from init.groovy"



import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*;
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
def embededJenkinsFile = System.getenv("EMBEDED_JENKINSFILE")?.toBoolean() ?: false;
def jenkinsfileBranch = "master";

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin', System.getenv("JENKINS_ADMIN_PASSWORD"));
instance.setSecurityRealm(hudsonRealm)

def strategy = new hudson.security.GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "admin")
instance.setAuthorizationStrategy(strategy)

instance.save()

// Add job git credentials
def repo_credentials = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,System.getenv("REPOSITORY_CREDENTIALS"), "Used to download the project from its repository", System.getenv("PROJECT_REPOSITORY_USERNAME"),System.getenv("PROJECT_REPOSITORY_PASSWORD"))
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), repo_credentials)

// Add Jenkinsfile
def scm = new GitSCM(System.getenv("PROJECT_JENKINSFILE_GIT_URL"))

if(embededJenkinsFile)
{
	// Add the project job
	scm.userRemoteConfigs = GitSCM.createRepoList(System.getenv("PROJECT_JENKINSFILE_GIT_URL"),repo_credentials.id)
	jenkinsfileBranch = System.getenv("BRANCH");
}

scm.branches = [new BranchSpec("*/"+jenkinsfileBranch)];
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(instance, System.getenv("REPOSITORY_NAME") + "_" + System.getenv("BRANCH"))
job.definition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, System.getenv("PROJECT_JENKINSFILE_NAME"))

instance.reload()

// Disable security for running scripts.
PermissiveWhitelist.MODE = Mode.NO_SECURITY
print "Finished initialization from init.groovy"
#!groovy
@Library('Utils')
import com.redhat.*

properties([disableConcurrentBuilds()])

node {
    def source = ""
    def dockerfiles = null
    String scmUrl = scm.browser.url
    String scmRef = "master"

    if(env.CHANGE_BRANCH) {
        scmRef = "${env.CHANGE_BRANCH}"
    }

    /* Checkout source and find all the Dockerfiles.
     * This will not include Dockerfiles with extensions. Currently the issue
     * with using a Dockerfile with an extension is the oc new-build command
     * does not offer an option to provide the dockerfilePath.
     */
    stage('checkout') {
        checkout scm
        dockerfiles = findFiles(glob: '**/Dockerfile')
    }


    for (int i = 0; i < dockerfiles.size(); i++) {

        def resources = null
        try {
        /* Execute oc new-build on each dockerfile available
         * in the repo.  The context-dir is the path removing the
         * name (i.e. Dockerfile)
         */
            def is = ""
            def dockerImageRepository = ""
            String path = dockerfiles[i].path.replace(dockerfiles[i].name, "")

            String normalizeRef = scmRef.replace('_', '-').toLowerCase()
            String normalizePath = path.replace('/','').replace('_','-').toLowerCase()

            String buildName = "${normalizePath}.${normalizeRef}"

            newBuild = newBuildOpenShift() {
                name = buildName
                url = scmUrl
                branch = scmRef
                contextDir = path
                deleteBuild = false
                randomName = false
            }

            /* OpenShift Run Section
             * Will re-enable this after additional testing of the build process

            dockerImageRepository = getImageStreamRepo(newBuild.buildConfigName).dockerImageRepository

            runOpenShift {
                deletePod = true
                branch = scmRef
                image = dockerImageRepository
                env = ["foo=goo"]
            }

            resources = newBuild.names
            */
            currentBuild.result = 'SUCCESS'
        }
        catch(all) {
            currentBuild.result = 'FAILURE'
            echo "Exception: ${all}"
        }
        finally {
            stage('Clean Up Resources') {
            echo "Clean up..."
            /* This is used with OpenShift Run.

               openshift.withCluster() {
                    openshift.withProject() {
                        for (r in resources) {
                            openshift.selector(r).delete()
                        }
                    }
                }
            */
            }
        }
    }
}

// vim: ft=groovy

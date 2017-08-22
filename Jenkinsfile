#!groovy
@Library('Utils')
import com.redhat.*

properties([disableConcurrentBuilds()])

node {

    def source = ""
    def dockerfiles = null
    String scmUrl = scm.browser.url
    String scmRef = "master"
    String buildName = ""


    if(env.CHANGE_BRANCH) {
        scmRef = "${env.CHANGE_BRANCH}"
    }
    else if(env.BRANCH_NAME) {
        scmRef = "${env.BRANCH_NAME}"
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
        def is = ""
        def dockerImageRepository = ""
        String path = dockerfiles[i].path.replace(dockerfiles[i].name, "")

        String normalizeRef = scmRef.replace('_', '-').toLowerCase()
        String normalizePath = path.replace('/','').replace('_','-').toLowerCase()

        buildName = "${normalizePath}-${normalizeRef}"

        if(buildName.contains("scratch")) {
            continue
        }

        try {
        /* Execute oc new-build on each dockerfile available
         * in the repo.  The context-dir is the path removing the
         * name (i.e. Dockerfile)
         */


            println(">>>>> buildName: ${buildName}")
            println(">>>>> scmRef: ${scmRef}")
            println(">>>>> scmUrl: ${scmUrl}")

            newBuild = newBuildOpenShift() {
                name = buildName
                url = scmUrl
                branch = scmRef
                contextDir = path
                deleteBuild = false
                randomName = false
            }

            dockerImageRepository = getImageStreamRepo(newBuild.buildConfigName).dockerImageRepository

            runOpenShift {
                name = buildName
                deletePod = false
                branch = scmRef
                image = dockerImageRepository
                env = ["foo=goo"]
            }

            /* move this in another revision of openshift-pipeline-library */
            stage('OpenShift exec') {
                openshift.withCluster() {
                    openshift.withProject() {
                        def exec = null
                        try {
                            exec = openshift.exec("${buildName} ps aux")
                            println("${exec.out}")
                        } catch(err) {
                            println("ps aux failed: ${err}")
                        }
                        try {
                            exec = openshift.exec("${buildName} whoami")
                            println("whoami: ${exec.out}")
                        } catch(err) {
                            println("whoami failed: ${err}")
                        }
                    }
                }
            }

            resources = newBuild.names

            currentBuild.result = 'SUCCESS'
        }
        catch(all) {
            currentBuild.result = 'FAILURE'
            echo "Exception: ${all}"
        }
        finally {
            stage('Clean Up Resources') {
                echo "Clean up..."
                openshift.withCluster() {
                    openshift.withProject() {
                        openshift.selector("pod/${buildName}").delete()
                        for (r in resources) {
                            openshift.selector(r).delete()
                        }
                    }
                }
            }
        }
    }
}

// vim: ft=groovy

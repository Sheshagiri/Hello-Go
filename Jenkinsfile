node {
    def app
    def container_name = "hello-go"

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("${env.registry}/${env.repository}/hello-go:${env.BUILD_NUMBER}")
    }

    stage('Test image') {
    
        app.inside {
            sh 'echo "No tests to run."'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry("https://${env.registry}", 'quay-io') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('Create/Update service') {
        createService(container_name)   
    }
}

def createService(containerName){
    sh "docker service ls"
    def docker_services = sh (script: "docker service ls --filter name=$containerName | grep -w $containerName | wc -l", returnStdout: true).toString().trim()
    echo "Number of docker service's for $containerName: ${docker_services}"
    if (docker_services != "0") {
        sh "docker service ls"
        echo "docker service is already created, will update the service with new image(${env.registry}/${env.repository}/hello-go:${env.BUILD_NUMBER}) instead of creating a new one"
        sh "docker service update --image ${env.registry}/${env.repository}/hello-go:${env.BUILD_NUMBER} $containerName"
        echo "updated docker service"
        sh "docker service ls"
    } else {
        echo "docker service is not created, creating a new service now with ${env.registry}/${env.repository}/hello-go:${env.BUILD_NUMBER} as image"
        sh "docker service create --name $containerName --publish 8000:8000 ${env.registry}/${env.repository}/hello-go:${env.BUILD_NUMBER}"
        echo "Service got created and runs on port 8000"
    }
    //echo "Removing docker service"
    //sh "docker service rm hello-go"
    //sh "docker service ls"
}


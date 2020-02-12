Docker Jenkins
==============

Run Jenkins Master Docker
-------------------------
1. $ sudo docker volume create {jenkins_volume}
2. $ sudo docker run -d --name {container_name} \
                    -p 50000:50000 \
                    -p 8080:8080 \
                    -v {jenkins_volume}:/var/jenkins_home \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    -v /etc/timezone:/etc/timezone:ro \
                    -v /etc/localtime:/etc/localtime:ro \
                    --privileged \
                    --restart always \
                    {jenkins_container_image}
3. $ sudo docker exec {jenkins_container_name} cat /var/jenkins_home/secrets/initialAdminPassword

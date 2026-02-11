#!/usr/bin/env bash
#set -x

PROJECTS=(
          "6666"
          "7749"
          "7772"
          "7774"
          "7775"
          "7799"
          )

if ! [ -z "$1" ]; then
     PROJECTS=( "$1" )
fi


for PROJECT in "${PROJECTS[@]}"; do

    echo "********************************************************"
    echo "START PROJECT = $PROJECT"
    echo "********************************************************"

    echo "--------------------------------------------------------"
    echo "--------- ${PROJECT} - P Tarafi ---------------------"
    echo "--------------------------------------------------------"

    if [[ "$2" == "gpy" || "$2" == "" ]]; then
        ./sonar.sh --sonar-project-key="gpy${PROJECT}" \
           --git-url="gitlab.local.net/mycompany/gpy/${PROJECT}.git" \
           --git-user="batur.orkun" \
           --git-token="ydcTr7-_9DHbf52zztaz" \
           --git-branch="feature/dev_${PROJECT}" \
           --sonar-login="083bbd8097a51992db8c9d22d78f870a56791e86" \
           --sonar-host="http://sonarqube.local.net" \
           --sonar-java-binaries="Kurulum/plugins/GPY"
    fi

    echo "--------------------------------------------------------"
    echo "--------- ${PROJECT} - Main Tarafi ---------------------"
    echo "--------------------------------------------------------"

    if [[ "$2" == "gpymain" || "$2" == "" ]]; then
        ./sonar.sh  --sonar-project-key="gpymain${PROJECT}" \
           --git-url="gitlab.local.net/mycompany/gpy/gpy_main.git" \
           --git-user="batur.orkun" \
           --git-token="ydcTr7-_9DHbf52zztaz" \
           --git-branch="feature/dev_${PROJECT}" \
           --sonar-login="083bbd8097a51992db8c9d22d78f870a56791e86" \
           --sonar-host="http://sonarqube.local.net" \
           --sonar-java-binaries="Gelistirme/GPY"
    fi

    echo "********************************************************"
    echo "END PROJECT = $PROJECT"
    echo "********************************************************"

    echo "########################################################"
    echo "########################################################"
done

echo "######################## FINISHED ################################"
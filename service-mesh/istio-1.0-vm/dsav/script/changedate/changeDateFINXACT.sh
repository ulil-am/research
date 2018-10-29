#!/bin/bash
TMPPATH=$PWD
cd /data/jenkins_data/FINXCORE/cicd

cp dsav-txn-deploy.yaml dsav-txn-deploy_test.yaml

OFFSET_DAY=$1
OFFSET_HOUR=$(expr ${OFFSET_DAY} \* 24)

echo "changing date in finxact server for  offset "${OFFSET_DAY}
echo "changing date in finxact server for  offset "${OFFSET_HOUR}"h"

if [ ${OFFSET_DAY} == 0 ]
then
    kubectl delete -f dsav-txn-deploy.yaml
    sleep 10
    kubectl create -f dsav-txn-deploy.yaml
    sleep 10
    cd $TMPPATH
    ./wait-for.sh pod -l "app=dsav-txn"
    exit
fi


sed -i 's/name: TO_REPLACE_Finxact_Debug/name: Finxact_Debug/g' dsav-txn-deploy_test.yaml
sed -i 's/name: TO_REPLACE_Finxact_TimeOffset/name: Finxact_TimeOffset/g' dsav-txn-deploy_test.yaml
sed -i 's/value: "TO_REPLACE_TimeOffset"/value: "'${OFFSET_HOUR}'h"/g' dsav-txn-deploy_test.yaml

kubectl delete -f dsav-txn-deploy_test.yaml
sleep 10
kubectl create -f dsav-txn-deploy_test.yaml
sleep 10
 cd $TMPPATH
./wait-for.sh pod -l "app=dsav-txn"
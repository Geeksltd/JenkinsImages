$CONTEXT=$args[0]
$CURRENT_TAG=type $CONTEXT\CurrentVersionTag.txt
$LATEST_TAG="$($CURRENT_TAG.Split(":")[0]):latest"
docker tag $CURRENT_TAG $LATEST_TAG
docker push $CURRENT_TAG
docker push $LATEST_TAG
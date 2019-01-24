$CONTEXT=$args[0]
docker build -t $(type $CONTEXT\CurrentVersionTag.txt) $CONTEXT
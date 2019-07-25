docker run -it -e DISPLAY=$DISPLAY -v ~:/home/faraz --runtime=nvidia --net=host --ipc=host -v $XAUTHORITY:/root/.Xauthority ros:latest

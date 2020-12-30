docker run \
  -it \
  --rm \
  --name console \
  --user root \
  --volume `pwd`:`pwd` \
  --workdir `pwd` \
  python:3.6.12-buster /bin/sh
#  python:3.6.12-alpine3.12 /bin/sh


#  --user `id -u`:`id -g` \

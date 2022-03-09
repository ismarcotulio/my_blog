sudo docker build . -t alpine-jekyll
sudo docker run -v $PWD/docs:/home/docs -p "4000:4000" -it alpine-jekyll


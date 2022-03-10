sudo docker build . -t ubuntu-jekyll
sudo docker run -v $PWD/docs:/home/docs -p "3000:4000" -it ubuntu-jekyll ./home/docs/start_serve.sh


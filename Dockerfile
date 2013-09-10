from base

maintainer Micha Hernandez van Leuffen

#install RethinkDB

run apt-get install -y software-properties-common
run add-apt-repository -y ppa:rethinkdb/ppa
run apt-get update
run apt-get install -y rethinkdb

EXPOSE 28015
EXPOSE 8080
ENTRYPOINT ["/usr/bin/rethinkdb", "--bind", "all"]


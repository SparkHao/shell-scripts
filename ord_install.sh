image_name='btcdomain_resolver_mysql'
pwd='btcdomain'
port=3306

cur_dir=$(cd $(dirname $0);pwd)
echo 'cur_dir: '$cur_dir
echo 'docker start ' $image_name
sudo apt update

py_version=`python3 -V 2>&1|awk '{print $2}'|awk -F '.' '{print $1$2}'`
if [ "$py_version" -lt "39" ];then
    sudo apt install python3.9-venv python3.9-dev -y
fi

echo $py_version

sudo docker pull mysql:latest

id=`sudo docker run -itd --name $image_name -p $port:$port -v $cur_dir/table.sql:/docker-entrypoint-initdb.d/table.sql -e MYSQL_ROOT_PASSWORD=$pwd mysql`

sleep 2
sudo docker start $id
#sudo docker start $image_name

echo $database

rm table.sql

sudo apt install python3-venv -y
python3 -m venv ~/cairo_venv
source ~/cairo_venv/bin/activate
sudo apt-get install python3-dev -y
sudo apt-get install libgmp3-dev -y
pip3 install cairo-lang

wget https://github.com/btcdomain/btcdomain_resolver/releases/download/v0.1.3/table.sql

rm btcdomain_resolver

wget https://github.com/btcdomain/btcdomain_resolver/releases/download/v0.1.3/btcdomain_resolver

chmod +x btcdomain_resolver

echo 'start btcdomain resolver'
export RUST_LOG=info
export database=mysql://root:$pwd@localhost:$port/domain_inscription_data


nohup ./btcdomain_resolver > btcdomain_resolver.log &

#!/bin/sh
initializeANSI()
{
 esc="\033[1m\033" # if this doesn't work, enter an ESC directly

 blackf="${esc}[30m";  redf="${esc}[31m";  greenf="${esc}[32m"
 yellowf="${esc}[33m"  bluef="${esc}[34m";  purplef="${esc}[35m"
 cyanf="${esc}[36m";  whitef="${esc}[37m"

 blackb="${esc}[40m";  redb="${esc}[41m";  greenb="${esc}[42m"
 yellowb="${esc}[43m"  blueb="${esc}[44m";  purpleb="${esc}[45m"
 cyanb="${esc}[46m";  whiteb="${esc}[47m"

 boldon="${esc}[1m";  boldoff="${esc}[22m"
 italicson="${esc}[3m"; italicsoff="${esc}[23m"
 ulon="${esc}[4m";   uloff="${esc}[24m"
 invon="${esc}[7m";   invoff="${esc}[27m"

 reset="\033[0m"
}
initializeANSI

waitInfo()
{
 local k=5;
 if  [ -n  $1  ]; then
  k=$1
 fi
 while((k>0))
 do
   sleep 1
   echo "$k..."
   let k--
 done
}


echo -e "$greenf----------------部署脚本-简化版----starting---------------${reset}" 
#echo -e "$bluef更新远程服务器代码...${reset}"
#git pull

#echo -e "$bluef执行migration...${reset}"
#rake db:migrate RAILS_ENV=production
#waitInfo
#echo -e "$bluef执行初始化脚本...${reset}"
#rake irm:initdata RAILS_ENV=production


cpid=`ps -ef | grep unicorn | grep "master -c"| awk '{print $2}'`
opid=`ps -ef | grep unicorn | grep master | grep old | awk '{print $2}'`

if [ ! -n "$cpid" ] && [ ! -n "$opid" ]; then
  echo -e  "$redf未检测到运行中的unicorn进程1...${reset}"
  sleep 1
  echo -e  "$redf未检测到运行中的unicorn进程2...${reset}"
  sleep 1
  echo -e  "$redf未检测到运行中的unicorn进程3...${reset}"
  sleep 1
  echo -e  "$yellowf准备执行unicorn（config/unicorn.rb）...${reset}"
  cpid=0
  waitInfo 3
  unicorn -c config/unicorn.rb -D -E production
elif [ -n "$cpid" ] && [ -n "$opid" ]; then
  echo -e  "$yellowf老进程已存在，进程pid：$opid，开始检测新进程...${reset}" 
elif [ -n "$cpid" ] && [ ! -n "$opid" ]; then
  echo -e  "$yellowf检测到运行中的unicorn: $cpid，准备重启unicorn...${reset}"
  kill -USR2 `cat tmp/pids/unicorn.pid`
  echo "重启中..."
  #waitInfo
fi


npid=
i=0

while(( i < 10 ))
do
     npid=`ps -ef | grep unicorn | grep "master -c" | awk '{print $2}'`
     oopid=`ps -ef | grep unicorn | grep master | grep old | awk '{print $2}'`

     if [ -n "$npid" ] && [ -n "$oopid" ]; then
       echo -e "$bluef新进程已启动，杀掉老进程...$reset"
       waitInfo
       kill -9 $oopid
       break
     fi

     if [ ! -n "$npid" ];then
       let i+=1
       sleep 1
       echo "未检测到unicorn新进程，第$i次..."
     elif [ "$cid" != "$npid" ]; then
       echo -e "${greenf}/*******unicorn部署成功******/...新进程pid: $npid$reset"
       exit 0
     fi
done
if [ ! -n "$npid" ]; then
  echo -e "$redf达到最大尝试次数，未检测到新进程，中止脚本，请手动核对...$reset"
  exit 0
fi

echo -e "${greenf}unicorn部署成功...新进程pid: $npid$reset"
sleep 2
echo "------------------------------------------------------------"
echo -e "$bluef重启sidekiq...$reset"
oskid=`ps -ef | grep sidekiq |grep 'of'| grep 'busy' | grep -v grep | awk '{print $2}'`
if [  -n "$oskid" ]; then
  echo -e "$yellowf检测到运行中的sidekiq: $oskid，准备重启sidekiq...$reset"
  kill -9 $oskid
  echo "重启中..."
else
  echo -e  "$redf未检测到sidekiq新进程，中止脚本，请手动核对...$reset"
  exit 0
fi
waitInfo
sidekiq -c 25 -L log/sidekiq.log -d &

i=0
while(( i < 50 ))
do
     skid=`ps -ef | grep sidekiq|grep 'of'|grep 'busy'| grep -v grep | awk '{print $2}'`

     if [  -n "$skid" ]; then
       echo -e "${greenf}sidekiq部署成功...新进程pid: $skid$reset"
       break
     else
       let i+=1
       sleep 1
       echo "未检测到新sidekiq进程，第$i次..."
     fi
done
if [ ! -n "$skid" ]; then
  echo -e "$redf达到最大尝试次数，未检测到sidekiq新进程，中止脚本，请手动核对...$reset"
  exit 0
fi

echo -e "$greenf$boldon----------------部署脚本-简化版----end---------------${reset}"


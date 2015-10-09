#!/bin/bash -x

#pre-processes
chown -R oacis:oacis /home/oacis/oacis/public/Result_development
chown -R oacis:oacis /home/oacis/work
if [ ! -f /home/oacis/oacis/config/mongoid.yml.orig ]
then
  sed -i".orig" -e s/localhost:27017/mongo:27017/g /home/oacis/oacis/config/mongoid.yml
fi
chown oacis:oacis /home/oacis/oacis/config/mongoid.yml*

#start ssh process
/usr/bin/supervisord

#run oacis
su - -c "\
  cd ~/oacis; \
  bundle exec rake daemon:start RAILS_ENV=production; \
  if [ ! -f ~/.ssh/id_rsa ]; then echo -e \"\\n\" | ssh-keygen -N \"\" -f $HOME/.ssh/id_rsa; cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys; chmod 600 $HOME/.ssh/authorized_keys; fi" \
  oacis;

su - -c "/bin/bash" oacis


echo -e "\ninclude 'custom.conf'" >> /var/lib/postgresql/data/postgresql.conf
cat <<EOF > /var/lib/postgresql/data/custom.conf
shared_buffers = 512MB
work_mem = 30MB
fsync = off 
EOF
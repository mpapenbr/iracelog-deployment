cp /custom.conf /var/lib/postgresql/data/
echo -e "\ninclude '/custom.conf'" >> /var/lib/postgresql/data/postgresql.conf

createuser -d -R -S odoo
cat << EOF | psql
BEGIN;
ALTER ROLE "odoo" WITH LOGIN;
END;
EOF

# #!/bin/sh
# # Docker entrypoint script.

# # Wait until Postgres is ready
# while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
# do
#   echo "$(date) - waiting for database to start"
sleep 15
# done

./prod/rel/banking_api/bin/banking_api eval BankingApi.Release.migrate

./prod/rel/banking_api/bin/banking_api start

#/bin/bash
docker compose run --rm ism-manager bash -c "alembic -c src/iracelog_service_manager/db/alembic.ini  upgrade head"
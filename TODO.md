use cli to import database
fix clone-server-database.sh chmod (no need to run it through the prepare-shell-script function - look into bash functions)
check if database already exists... don't attempt to create one... (could check if you ant to continue ith import?)

set .env cache to true
create multisite option + set domain is wp-config.php

why isn't https working? https://devilbox.readthedocs.io/en/latest/intermediate/setup-valid-https.html

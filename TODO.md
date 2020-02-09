bugs:
- fix clone-server-database.sh chmod (no need to run it through the prepare-shell-script function - look into bash functions)
- seems to be an error testing if a database exists. It tried to create one even though it already existed. This did not stop the script though

features:
- set Database Prefixto equal 'wp_' unless alternative provided
- set .env cache to true (regex required)
- create multisite option + set domain in wp-config.php
- why isn't https working? https://devilbox.readthedocs.io/en/latest/intermediate/setup-valid-https.html
- add echo statements/debugging/verbose options to describe process - helpful for debugging
- make paths dynamic!

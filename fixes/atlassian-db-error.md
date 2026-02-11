

Error: starting bitbucket hangs on "migrating home directory"
      or 
bitbucket SpringMVC dispatcher [springMvc] could not be started


Resolve:

DB yi tek basına ac icine docker exec ile gir

plsq -U postgres
    
    postgres # \c bitbucket         -- Connect DB bitbucket

    postgres # UPDATE DATABASECHANGELOGLOCK SET LOCKED=false, LOCKGRANTED=null, LOCKEDBY=null where ID=1;


Daha sonra diğer servileri başlat


kubectl -n cattle-system exec $(kubectl -n cattle-system get pods | grep ^rancher | head -n 1 | awk '{ print $1 }') -- reset-password

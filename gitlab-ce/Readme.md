# Initial root Password
Zu finden im Pod unter: /etc/gitlab/initial_root_password

    podman exec gitlab-1 grep "^Password" /etc/gitlab/initial_root_password | awk '{print $NF}'


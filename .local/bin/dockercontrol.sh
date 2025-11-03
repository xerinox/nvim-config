#!/bin/bash

selected_lines=$(docker ps -a --format "{{.ID}}|{{.State}}|{{.Names}}" | column -t -s'|' | \
    fzf --header "Use TAB to select multiple containers" --height=40% --multi)

if [ -z "$selected_lines" ]; then
    exit 0
fi

container_ids=$(echo "$selected_lines" | awk '{print $1}')

for container_id in $container_ids; do
    machine_status=$(docker inspect --format '{{.State.Status}}' "$container_id")
    container_name=$(docker inspect --format '{{.Name}}' "$container_id" | sed 's/^\///')

    if [ -z "$container_name" ]; then
        continue 
    fi

    echo "----------------------------------------"
    if [ "$machine_status" = "running" ]; then
        echo "Container '$container_name' is running."
        # This 'read' now correctly waits for keyboard input.
        read -p "Choose an action: (r)estart, (s)top, (q)uit processing: " choice
        case "$choice" in
            r|R ) docker restart "$container_name";;
            s|S ) docker stop "$container_name";;
            q|Q ) exit 0;;
            * ) echo "Invalid choice, skipping.";;
        esac
    else
        echo "Container '$container_name' is stopped (Status: $machine_status)."
        # This 'read' also works correctly now.
        read -p "Choose an action: (s)tart, (r)estart, (q)uit processing: " choice
        case "$choice" in
            s|S ) docker start "$container_name";;
            r|R ) docker restart "$container_name";;
            q|Q ) exit 0;;
            * ) echo "Invalid choice, skipping.";;
        esac
    fi
done

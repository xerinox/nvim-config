#!/usr/bin/env bash

# Dependencies: gh, fzf
#
# Usage:
# gh-interactive.sh <owner/repo> [command]
#
set -euo pipefail

tmp_file=""

cleanup() {
    [[ -n "$tmp_file" && -f "$tmp_file" ]] && rm "$tmp_file"
}
trap cleanup EXIT

# -- Pre-flight checks ---

for cmd in gh fzf jaq; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "$cmd is required"; exit 1; 
    }
done

if [[ -z "${1-}" ]]; then
    echo "Error: A repository (owner/repo) is required." >&2
    echo "Usage: $0 <owner/repo> [command]" >&2
    exit 1
fi

REPO="$1"
ACTION="${2:-interactive}"

_select_gh_issue() {
    gh issue list --repo "$REPO" --state all --json number,title,author,labels,state,createdAt \
        | jq -r '.[] | "\(.number)\t\(.title)\t\(.author.login)\t\(.state)\t\(.createdAt)"' \
        | fzf --height 50% --min-height 15 --layout=reverse --border \
            --prompt="Select issue > " \
            --header="Number | Title | Author | State | Created At" \
            --preview 'gh issue view {1} --repo '"$REPO"' --json number,title,author,labels,state,createdAt,body | jaq -r "
                \"Issue #\(.number): \(.title)\"
                + \"\nAuthor: \(.author.login)\"
                + \"\nState: \(.state)\"
                + (if .labels|length > 0 then \"\nLabels: \" + ([.labels[].name]|join(\", \")) else \"\" end)
                + \"\nCreated: \(.createdAt)\"
                + \"\n\n\(.body)\""' \
            --preview-window=up:60%:border-top \
            --bind "ctrl-o:reload(gh issue list --repo $REPO --state open --json number,title,author,labels,state,createdAt | jq -r '.[] | \"\(.number)\t\(.title)\t\(.author.login)\t\(.state)\t\(.createdAt)\"')" \
            --bind "ctrl-c:reload(gh issue list --repo $REPO --state closed --json number,title,author,labels,state,createdAt | jq -r '.[] | \"\(.number)\t\(.title)\t\(.author.login)\t\(.state)\t\(.createdAt)\"')" \
            --bind "ctrl-a:reload(gh issue list --repo $REPO --state all --json number,title,author,labels,state,createdAt | jq -r '.[] | \"\(.number)\t\(.title)\t\(.author.login)\t\(.state)\t\(.createdAt)\"')" | \
        awk '{print $1}'
}

_select_gh_action() {
    printf "View\nComment\nBrowse\nClose\nReopen" | \
        fzf --height 25% --min-height 8 --layout=reverse --border \
        --prompt="Action for Issue #${ISSUE_NUM} >"
}

interactive_mode() {
    local ISSUE_NUM
    ISSUE_NUM=$(_select_gh_issue)

    if [[ -z "$ISSUE_NUM" ]]; then
        echo "No issue selected."
        exit 0
    fi

    local SELECTED_ACTION
    SELECTED_ACTION=$(_select_gh_action)

    case "$SELECTED_ACTION" in
        "View")
            gh issue view "$ISSUE_NUM" -R "$REPO"
            ;;
        "Comment")
            local tmp_file
            tmp_file=$(mktemp)

            "${EDITOR:-vim}" "$tmp_file"
            if [[ -s "$tmp_file" ]]; then
                gh issue comment "$ISSUE_NUM" -R "$REPO" --body-file "$tmp_file"
                echo "Comment added to issue #$ISSUE_NUM."
            fi
            rm "$tmp_file"
            ;;
        "Browse")
            gh issue view "$ISSUE_NUM" -R "$REPO" --web
            ;;
        "Close")
            gh issue close "$ISSUE_NUM" -R "$REPO"
            echo "Issue #$ISSUE_NUM closed."
            ;;
        "Reopen")
            gh issue reopen "$ISSUE_NUM" -R "$REPO"
            echo "Issue #$ISSUE_NUM reopened."
            ;;
        *)
            echo "No valid action selected."
            exit 0
            ;;
    esac
}

create_pr() {
    gh pr create -R "$REPO"
}

case "$ACTION" in
    interactive)
        interactive_mode
        ;;
    pr)
        create_pr
        ;;
    *)
        echo "Unknown action: $ACTION"
        exit 1
        ;;
esac


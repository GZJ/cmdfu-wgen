#!/bin/bash

random_page=$((RANDOM % 100 + 1))

json_data=$(curl -s "https://www.commandlinefu.com/commands/browse/sort-by-votes/json/$random_page")

if [ -z "$json_data" ]; then
    echo "Failed to fetch JSON data from API." >&2
    exit 1
fi

generate_command_html() {
    local summary="$1"
    local command="$2"
    local url="$3"
    local votes="$4"
    
    cat << EOF
<div class="command-component" style="border: 2px solid #333; border-radius: 5px; padding: 15px; margin: 20px; max-width: 600px; font-family: Arial, sans-serif;">
  <style>
    .command-component .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }
    .command-component h3 {
      margin: 0;
    }
    .command-component a {
      color: #00a86b;
      text-decoration: none;
    }
    .command-component a:hover {
      text-decoration: underline;
    }
    .command-component pre {
      background-color: #000;
      padding: 10px;
      border-radius: 5px;
      overflow-x: auto;
    }
    .command-component code {
      color: #00ff00;
      font-family: 'Courier New', Courier, monospace;
    }
    .command-component .votes {
      color: #00a86b;
      font-size: 0.9em;
    }
  </style>
  <div class="header">
    <h3><a href="${url}" target="_blank">${summary}</a></h3>
    <span class="votes">Votes: ${votes}</span>
  </div>
  <pre><code>${command}</code></pre>
</div>
EOF
}

random_command=$(echo "$json_data" | jq -r '.[] | @base64' | shuf -n 1 | base64 --decode)

summary=$(echo "$random_command" | jq -r '.summary')
command=$(echo "$random_command" | jq -r '.command')
url=$(echo "$random_command" | jq -r '.url')
votes=$(echo "$random_command" | jq -r '.votes')

command_html=$(generate_command_html "$summary" "$command" "$url" "$votes")

cat << EOF
$command_html
EOF

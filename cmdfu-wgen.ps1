$randomPage = Get-Random -Minimum 1 -Maximum 100

$jsonData = Invoke-RestMethod -Uri "https://www.commandlinefu.com/commands/browse/sort-by-votes/json/$randomPage"

if ($null -eq $jsonData -or $jsonData.Count -eq 0) {
    Write-Error "Failed to fetch JSON data from API."
    exit 1
}

function Generate-CommandComponent {
    param (
        [string]$Summary,
        [string]$Command,
        [string]$Url,
        [int]$Votes
    )

    return @"
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
    <h3><a href="$Url" target="_blank">$Summary</a></h3>
    <span class="votes">Votes: $Votes</span>
  </div>
  <pre><code>$Command</code></pre>
</div>
"@
}

$randomCommand = $jsonData | Get-Random

$commandComponent = Generate-CommandComponent -Summary $randomCommand.summary `
                                              -Command $randomCommand.command `
                                              -Url $randomCommand.url `
                                              -Votes $randomCommand.votes

Write-Output $commandComponent

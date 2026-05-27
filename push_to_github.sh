#!/bin/bash
# Run this with: bash push_to_github.sh YOUR_GITHUB_TOKEN YOUR_USERNAME
TOKEN=$1
USERNAME=$2
REPO="walmart-ai-autopilot"

if [ -z "$TOKEN" ] || [ -z "$USERNAME" ]; then
  echo "Usage: bash push_to_github.sh <github_token> <github_username>"
  exit 1
fi

# Create repo via GitHub API
echo "Creating GitHub repo..."
curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO\",\"description\":\"Walmart Seller Center AI Autopilot — Multi-agent framework for autonomous catalog optimization\",\"private\":false}" | python3 -c "import sys,json; r=json.load(sys.stdin); print('Repo URL:', r.get('html_url','Error: '+str(r)))"

# Push
git remote add origin "https://$USERNAME:$TOKEN@github.com/$USERNAME/$REPO.git"
git branch -M main
git push -u origin main

echo "Done! Visit: https://github.com/$USERNAME/$REPO"

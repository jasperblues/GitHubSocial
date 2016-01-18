# GitHubSocial

Its nice to be able to follow back your followers on GitHub. This script reports:

- Followers you're not following back.
- Accounts being followed, not following you back.

# Installation

```sh
curl -SSL https://raw.githubusercontent.com/jasperblues/GitHubFollowMeBack/master/GitHubFollowMeBack.swift > GitHubFollowMeBack && chmod +x ./GitHubFollowMeBack
```

# Usage
```sh
./GitHubFollowMeBack <userName>
```

*NB:* GitHub rate limits unauthenticated users (eg this script) to x requests per hour.



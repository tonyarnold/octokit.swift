# Octokit.swift

## Installation

- **Using [Swift Package Manager](https://swift.org/package-manager)**:

```swift
import PackageDescription

let package = Package(
  name: "MyAwesomeApp",
  dependencies: [
    .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.11.0"),
  ]
)
```

## Authentication

Octokit supports both, GitHub and GitHub Enterprise.

Authentication is handled using Configurations.

There are two types of Configurations, `TokenConfiguration` and `OAuthConfiguration`.

### TokenConfiguration

`TokenConfiguration` is used if you are using Access Token based Authentication (e.g. the user
offered you an access token he generated on the website) or if you got an Access Token through
the OAuth Flow

You can initialize a new config for `github.com` as follows:

```swift
let config = TokenConfiguration("YOUR_PRIVATE_GITHUB_TOKEN_HERE")
```

or for GitHub Enterprise

```swift
let config = TokenConfiguration("YOUR_PRIVATE_GITHUB_TOKEN_HERE", url: "https://github.example.com/api/v3/")
```

After you got your token you can use it with `Octokit`

```swift
let user = try await Octokit(config).me()
```

### OAuthConfiguration

Use `OAuthConfiguration` if the user does not already have a GitHub access token. This will guide the user through handles the OAuth flow.

You can authenticate a user for `github.com` as follows:

```swift
let config = OAuthConfiguration(token: "<Your Client ID>", secret: "<Your Client secret>", scopes: ["repo", "read:org"])
let url = config.authenticate()
```

or for GitHub Enterprise

```swift
let config = OAuthConfiguration("https://github.example.com/api/v3/", webURL: "https://github.example.com/", token: "<Your Client ID>", secret: "<Your Client secret>", scopes: ["repo", "read:org"])
```

After you have a valid configuration, you will be able to authenticate the user:

```swift
// AppDelegate.swift

config.authenticate()

func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
  Task {
    try await config.handleOpenURL(url)
    try await loadCurrentUser(config: config) // purely optional of course
  }
  return false
}

func loadCurrentUser(config: TokenConfiguration) async throws {
  let user = try await Octokit(config).me()
  print(user.login)
}
```

Please note that the OAuth flow will return a instance of `TokenConfiguration`.
You need to store the `accessToken` yourself. If you want to make further requests it is not necessary to go through the OAuth Flow again. You can just use the `TokenConfiguration` that you already have.

```swift
let token = // get your token from your keychain, user defaults (not recommended) etc.
let config = TokenConfiguration(token)
let user = try await Octokit(config).user(name: "octocat")
print("User login: \(user.login!)")
```

## Users

### Get a single user

```swift
let username = ... // set the username
let user = try await Octokit().user(name: username)
```

### Get the authenticated user

```swift
let user = try await Octokit().me()
```

## Repositories

### Get a single repository

```swift
let (owner, name) = ("owner", "name") // replace with actual owner and name
let repository = try await Octokit().repository(owner, name)
```

### Get repositories of authenticated user

```swift
let repositories = try await Octokit().repositories()
```

## Starred Repositories

### Get starred repositories of some user

```swift
let repositories = try await Octokit().stars("username")
```

### Get starred repositories of authenticated user

```swift
let repositories = try await Octokit().myStars()
```

## Follower and Following

### Get followers of some user

```swift
let users = try await Octokit().followers("username")
```

### Get followers of authenticated user

```swift
let users = try await Octokit().myFollowers()
```

### Get following of some user

```swift
let users = try await Octokit().following("username")
```

### Get following of authenticated user

```swift
let users = try await Octokit().myFollowing()
```

## Issues

### Get issues of authenticated user

Get all issues across all the authenticated user's visible repositories including owned repositories, member repositories, and organization repositories.

```swift
let issues = try await Octokit(config).myIssues()
```

### Get a single issue

```swift
let (owner, repo, number) = ("owner", "repo", 1347) // replace with actual owner, repo name, and issue number
let issue = try await Octokit(config).issue(owner, repository: repo, number: number)
```

### Open a new issue

```swift
let issue = try await Octokit(config).postIssue("owner", repository: "repo", title: "Found a bug", body: "I'm having a problem with this.", assignee: "octocat", labels: ["bug", "duplicate"])
```

### Edit an existing issue

```swift
let issue = try await Octokit(config).patchIssue("owner", repository: "repo", number: 1347, title: "Found a bug", body: "I'm having a problem with this.", assignee: "octocat", state: .Closed)
```

### Comment an issue

```swift
let comment = try await Octokit().commentIssue(owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment")
```

### Edit an existing comment

```swift
let comment = try await Octokit().patchIssueComment(owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment")
```

## Pull requests

### Get a single pull request
```swift
let pullRequests = try await Octokit().pullRequest(owner: "octocat", repository: "Hello-World", number: 1)
```

### List pull requests
```swift
let pullRequests = try await Octokit().pullRequests(owner: "octocat", repository: "Hello-World", base: "develop", state: .Open)
```

### Update an exisiting Pull Request
```swift
let pullRequest = try await Octokit().patchPullRequest(session, owner: "octocat", repository: "Hello-World", number: 1, title: "Updated title", body: "The updated body", state: .open, base: "base-branch", mantainerCanModify: true)
```

## Releases

### Create a new release
```swift
let release = try await Octokit().postRelease(owner: "octocat", repository: "Hello-World", tagName: "v1.0.0", targetCommitish: "master", name: "v1.0.0 Release", body: "The changelog of this release", prerelease: false, draft: false)
```

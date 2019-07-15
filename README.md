# SearchGithubUsers
- Display Github users with avatar and name
- Can search users by name
- Pagingnation, can automatically load next page

# Notes
 - There are some run-time warnings caused by 3rd-party library, and we can ignore them.
 - Currently app is not applied any cache mechanism for GitHub api rate limit, so it might show toast messages to tell this.

# 3rd party libraries used in the project
 - SDWebImage
 - Alamofire
 - Toaster (To display errors coming from APIs)

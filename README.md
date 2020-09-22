# reddit

## Intro:
This basic iOS application showcases some of my coding practices and style. It features a split view controller that displays a list of reddits in the master section and the details of each reddit in the details section.

## Architecture
### Modular architecture:
- If this app were to scale, each new module (e.g. a new scene) would be implemented in a separate project, or in a Swift Package as it corresponds.

### Reddit project, architecture and some notes:
- Environment KickStarter's approach for easier dependency injection ( See talk by Stephen Cells https://vimeo.com/291588126)
- Coordinator Pattern (https://khanlou.com/) for navigation, just a MainCoordinator,
- It's fair to say that the Reddits Scene uses MVVM, but each scene might have different needs. So I wouldn't say MVVM is the chosen architecture.
- Storyboards were used in this occasion, but individual storyboards, one per each screen. I actually prefer xib files, but I've used them as it was a requirement.
- Persistence was done using a json file, but it's prepared for other alternatives. 
- Unit testing was done on some things, particularly to check that the time from now function works well.
- SceneDelegate and Main storyboard were kept to solve an annoying master/details bug using the split view controller. I'd gladly remove those and let the coordinator initialize the navigation entirely. 

### Workspace organization:
- The 3 SPMs contain app-independent code that can be used in other projects. See each package documentation for a little more info.
- `Base`: Contains extensions and basic utilities that can be reused
- `Endpoints`: Contains convenience entities and functions to talk to endpoints in a more seamless, light way, using `NSUrlSession` directly.
- `Reddit-api`: Contains some entities and backend informatio to instantiate endpoints and talk to the api.
- The Reddit project.  

## Application
### Features: 
- Talks to the reddit api (https://www.reddit.com/dev/api) to fetch the top posts in a table view
- Loads more posts and pages as the user scrolls down
- Pull to refresh and reload all posts
- Dismiss all posts
- Dismiss a single post (delete by swipe gesture)
- See posts details
- Mark posts as read
- Saves app state in a json file
- Saves images in the photo gallery
- Caches images for faster reloading when the table is prefetching
- Targets iOS13
- Supports both iPhone and iPad

### Known issues & missing features: 
- Image cache is not working, I need to debug it, so it's disconnected atm.
- The stubbing behavior does not support body/queries, so complex endpoint calls are hard to stub.
- The stubbing mechanism does not work well in conjunction with the .map operator, It needs more work so it's fixed. if you stub Endpoint<Element>.map(\.child) it will look for stub-Child.json instead of stub-Element.json and then convert usin the map function.

### TODOs:
- Localization
- Accessibility optimizations
- Dark Mode optimizations


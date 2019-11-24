# NHL-team-list
Mobile Swift project to display all NHL teams and rosters.

## 3rd party libraries

1. [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP request manager
2. [Kingfisher](https://github.com/onevcat/Kingfisher) - Image download manager
3. [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper) - JSON to object mapper
4. [SideMenu](https://github.com/jonkykong/SideMenu) - View controller to manage the sliding view

## Development notes

* Entire Pod directory is in git. I have found that more convenient when working on a team with a fast moving project. Each checkout has a snapshot that works.
* New projects in Xcode 11 have the option to use SwiftUI. At this moment I'm not particularly familiar with that, so I'm using the storyboard/XIB style.
* Normally when working in a team I avoid use of Storyboards beyond the main view controller. This is because the Storyboard file is not conventional XML and doesn't work well with version control. In this case the side menu library I chose prefers more structure.

## Total development time
**2.5 hours**

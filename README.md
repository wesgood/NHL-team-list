# NHL-team-list
Mobile Swift project to display all NHL teams and rosters.

Uses Xcode 11, iOS 13 and Swift 5.

## 3rd party libraries

1. [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP request manager
2. [Kingfisher](https://github.com/onevcat/Kingfisher) - Image download manager
3. [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper) - JSON to object mapper
4. [SideMenu](https://github.com/jonkykong/SideMenu) - View controller to manage the sliding view
5. [SDWebImageSVGCoder](https://github.com/SDWebImage/SDWebImageSVGCoder) - Render team logo SVGs in table cell

## APIs

These are from the github link provided as well as searching for related content.

1. NHL - https://gitlab.com/dword4/nhlapi/blob/master/stats-api.md
2. NHL team logos - https://www-league.nhlstatic.com
3. Player portraits - https://nhl.bamcontent.com
4. Country flags - https://restcountries.eu

## Development notes

* Entire Pod directory is in git. I have found that more convenient when working on a team with a fast moving project. Each checkout has a snapshot that works.
* New projects in Xcode 11 have the option to use SwiftUI. At this moment I'm not particularly familiar with that, so I'm using the storyboard/XIB style.
* Normally when working in a team I avoid use of Storyboards beyond the main view controller. This is because the Storyboard file is not conventional XML and doesn't work well with version control. In this case the side menu library I chose prefers more storyboard structure.
* The unsatisfied constraint error log appears to be a bug from Apple relating to the action sheet. See [this discussion](https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints) for more
* The API structure is inconsistent for players on the roster vs retrieving individual player data. This is why the mapping for players has a separate section.
* The data in the API matches NHL.com but appears to be incorrect relating to positions. Most teams have many more centres than expected.

## Total development time
**5.5 hours**

This is slightly more than expected but is otherwise close to what I would estimate for a client. Some of the extra time was used for working with the side menu library and sorting out the API structure.

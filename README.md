# movie-list

The project is about to work with the [Trakt.tv API](http://docs.trakt.apiary.io/#) and give the users two opportunities.

1. When the user starts the app, he will see a list with the **10 most popular movies** and by scrolling down a new request will be executed to show the next ten movies.
2. The User can switch via Tabs between showing the 10 most popular movies and **searching** movies. The search will be executed automatically while typing the searchterm. Also it should be scrollable via pagination.


## Installation

To install it download it or clone and then start `pod install` in the project directory.

After that open the `.xcworkspace` file.

## Framework Reference

- Use [HanekeSwift](https://github.com/Haneke/HanekeSwift) for image caching

- Use [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) for dealing with JSON data

- Use [ReactiveX](https://github.com/ReactiveX/RxSwift/tree/rxswift-2.0) especially to make the dynamic search

## API Reference

- Use [Trakt.tv API](http://docs.trakt.apiary.io/#) to request movies

## Btw

- Use [The Official raywenderlich.com Swift Style Guide](https://github.com/raywenderlich/swift-style-guide) as swift style guide
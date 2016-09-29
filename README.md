# movie-list

The project is about to work with the [Trakt.tv API](http://docs.trakt.apiary.io/#) and give the users two opportunities.

1. When the user starts the app, he will see a list with the **10 most popular movies** and by scrolling down a new request will be executed to show the next ten movies.
2. The User can switch via Tabs between showing the 10 most popular movies and **searching** movies. The search will be executed automatically while typing the searchterm. Also it should be scrollable via pagination.

## Result

![](https://media.giphy.com/media/26hisH3Fo6prTyFFK/giphy.gif)

## Installation

- Use [CocoaPods](https://cocoapods.org/) as dependency manager

To install, download it or clone and then start `pod install` in the project directory.

After that open the `.xcworkspace` file.

## Project Structure

- Use Xcode Groups for project structure

![](http://i.imgur.com/E3ACS1B.png)

- App: The app delegate, assets and info.plist
- APIs: The request handling with the trakt api
- Extensions: Extensions for different classes e.g. String
- Helpers: For making changes in one place in this case the cell identifiers
- Models: The movie models and a factory to create the movies
- Views: Everything regarding to the UI e.g. main storyboard, nibs
- Controllers: Controllers for the views

## Framework Reference

- Use [HanekeSwift](https://github.com/Haneke/HanekeSwift) for image caching

- Use [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) for dealing with JSON data

- Use [ReactiveX](https://github.com/ReactiveX/RxSwift/tree/rxswift-2.0) especially to make the dynamic search

## API Reference

- Use [Trakt.tv API](http://docs.trakt.apiary.io/#) to request movies

## Btw

- Use [The Official raywenderlich.com Swift Style Guide](https://github.com/raywenderlich/swift-style-guide) as swift style guide

- Use [Git](https://git-scm.com/) for version control

## For Improvement

- Use Tests
- Better loading handling of movies, especially images
- Add Loading Screen
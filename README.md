# SwiftAnnoy

SwiftAnnoy provides an interface (bindings) to the [Annoy](https://github.com/spotify/annoy) (Approximate Nearest Neighbors Oh Yeah) C++ library.

## Background
Nearest neighbors search (NNS) algorithms are used in a variety of tasks that include classification, clustering, image retreval, and recommendation.  The fundamental task in NNS is to look for points (examples) in a data set that are closest to a given query using some metric of distance (manhattan, euclidean, etc.).  Brute force search quickly becomes inefficient as the size of a dataset and number of dimensions in the data grow (see [the curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality).  Searching can be made more efficient by intelligent indexing (k-d trees, ball tree, etc.), but even here large datasets quickly lead to large indexes, memory constraints, and suboptimal search speed.
Approximate nearest neighbors algorithms make a trade-off in reduced guaranteed accuracy for improved query performance.  Annoy had been adopted in this library as it offers benefits in both speed and memory footprint (indexes are memory mapped.)

## Installation
Swift Package Manager (SPM)

1. In Xcode select File > Swift Packages > Add Package Dependency. 
2. copy and paste https://github.com/jbadger3/SwiftAnnoy into the search URL
3. Select SwiftAnnoy and click next.
4. Choose a rule for dependency management.  Click next.
5. Click Finish.

## Usage
### Supported data types
- [ ] Float16 (half-precision)
- [x] Float (32 bit)
- [x] Double (64 bit)
### Supported distance metrics
- [x] angular
- [x] dotProcut
- [x] euclidean
- [ ] hamming
- [x] manhattan

## Contributing
Improvements and suggestions are welcome.  Have a look at the todo list below or open up an issue for other areas of improvement.

## ToDo
This is not exactly a roadmap, but includes areas of testing 
### Features
- [ ] hamming distance
- [ ] bounds checking for getItem, getNNsForItem, and getNNsForVector

### Unit testing
- [ ] build
- [ ] unbuild
- [ ] unload
- [ ] setVerbose
- [ ] getItem
- [ ] setSeed
- [ ] onDiskBuild

### Memory management
- [ ] test for memory leaks
- [ ] verify mmap and prefault function properly

### OS/device testing
- [ ] macOS
- [ ] iOS
- [ ] Linux

## License

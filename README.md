# SwiftAnnoy

SwiftAnnoy provides an interface (bindings) to the [Annoy](https://github.com/spotify/annoy) (Approximate Nearest Neighbors Oh Yeah) C++ library.

### Supported data types
- [ ] Float16 (half-precision)
- [x] Float (32 bit)
- [x] Double (64 bit)

### Supported distance metrics (similarity measures)
- [x] angular
- [x] dotProcut
- [x] euclidean
- [ ] hamming
- [x] manhattan

## Background
Nearest neighbors search (NNS) algorithms are used in a variety of tasks that include classification, clustering, image retreval, and recommendation.  The fundamental task in NNS is to look for points (examples) in a data set that are closest to a given query using some metric of distance (manhattan, euclidean, etc.).  Brute force search quickly becomes inefficient as the size of a dataset and number of dimensions in the data grow (see [the curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality)).  Searching can be made more efficient by intelligent indexing (k-d trees, ball tree, etc.), but even here large datasets quickly lead to large indexes, memory constraints, and suboptimal search speed.

Approximate nearest neighbors algorithms make a trade-off in reduced accuracy for improved query performance.  Annoy offers benefits in both speed and memory footprint (indexes are memory mapped) that make it an attractive alternative to brute force search and exact nearest neighbor methods.

## Installation
Swift Package Manager (SPM)
If you are using Xcode you can do the following:
1.  Select File > Swift Packages > Add Package Dependency. 
2. copy and paste https://github.com/jbadger3/SwiftAnnoy into the search URL
3. Select SwiftAnnoy and click next.
4. Choose a rule for dependency management.  Click next.
5. Click Finish.

## Usage
Using SwiftAnnoy is fairly straitforward.  You can follow the code snippets below to get started.

### Create an index
  First, create an `AnnoyIndex<T>`  as in:
```
let index = AnnoyIndex<Double>(itemLength: 2, metric: .euclidean)
```
Currently supported types are `Float` and `Double`.

### Adding items
Next, add some data to your index.  There are two functions that can be used to populate an index: `addItem` and `addItems`.
```
var item0 = [1.0, 1.0]
var item1 = [3.0, 4.0]
var item2 = [6.0, 8.0]
var items = [[item0, item1, item2]]

// add one item
try? index.addItem(index: 0, vector: &item0)

// add multple items
try? index.addItems(items: &items)
```
Note:  Annoy expects indices in chronological order from 0...n-1.  If you need/intend to use some other id numbering system create your own mapping as memory will be allocated for max(id) + 1 items.

### Build the index
In order to run queries on an `AnnoyIndex` the index must first be built.
```
try? index.build(numTrees: 1)
```
The argument `numTrees` specifies the number of trees you want Annoy to use to construct the index.  The more trees you include in the index the more accurate the search results will be, but it will take longer to build, take up more space, and require more time to search.  Experiment with this parameter to optimize the tradeoffs.

### Running queries
An `AnnoyIndex`  can be queried using either an item index or a vector.
```
// by item
let results =  index.getNNsForItem(item: 3, neighbors: 3)
print(results)
"Optional((indices: [3, 2, 0], distances: [0.0, 5.0, 8.602325267042627]))"

// by vector
var vector = [3.0, 4.0]
let results2 = index.getNNsForVector(vector: &vector, neighbors: 3)
print(results2)
"Optional((indices: [2, 0, 1], distances: [0.0, 3.605551275463989, 3.605551275463989]))"
```




## Contributing
Improvements and suggestions are welcome.  Have a look at the TODO list below or open up an issue for other areas of improvement.

## TODO

### Features
- [ ] hamming distance
- [ ] bounds checking for getItem, getNNsForItem, and getNNsForVector
- [ ] 

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
SwiftAnnoy is released with an MIT [license](https://github.com/jbadger3/SwiftAnnoy/blob/master/LICENSE).  If you use SwiftAnnoy in another project, please add a link to this repository in your acknowledgements.

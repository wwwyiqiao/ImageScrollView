# ImageScrollView
infinite scrolling loop and auto scrolling, support autolayout

### Usage
add file `ImageScrollView.swift` to your project

##### Set properties

```
imageScrollView.images = images
imageScrollView.isAutoScroll = true
imageScrollView.imageClickedHandler = { (indexOfImage) -> Void in
  print("the index of clicked image: \(indexOfImage)")
}
```

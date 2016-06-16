# ImageScrollView
infinite scrolling loop and auto scrolling

### Usage
add file `ImageScrollView.swift` to your project

##### Use Interface Builder


##### Programmatically

`let imageScrollView = ImageScrollView(frame: frame)`

##### Set properties

```
imageScrollView.images = images
imageScrollView.isAutoScroll = true
imageScrollView.imageClickedHandler = { (indexOfImage) -> Void in
  print("the index of clicked image: \(indexOfImage)")
}
```

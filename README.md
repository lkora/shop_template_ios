# Shop template iOS

A task app given to me.

A two view app that demonstrates the following:
1. Fetch the data from the API (https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline)
2. Parse and display the data in CollectionView
3. Transition to an other more detailed view of the selected product
4. Be able to navigate back

Noteworthy comments:
1. Content is loaded from the API, and loads asynchronously
2. Images are also downloaded and showed asynchronously
3. Caching of images has been done using NSCache
3. Small animations added to the cards inside CollectionView, and in the detail view's bottom bar

## Demo
![app](https://user-images.githubusercontent.com/17961880/183308383-acf6f4db-a6fc-4425-b2f9-73ef124bf878.gif)

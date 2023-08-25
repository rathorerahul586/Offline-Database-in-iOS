# Offline-Database-in-iOS


# Project Title

Storing data offline in iOS can be done using various storage mechanisms depending on your specific use case and requirements. Here are some options:

1. **UserDefaults:**
   UserDefaults is a simple key-value storage for small amounts of data, such as settings or user preferences. It's suitable for storing basic data types like strings, numbers, and booleans.

2. **Keychain:**
   The Keychain is a secure storage option for sensitive data like passwords, tokens, or credentials. It's designed to keep data encrypted and protected from unauthorized access.

3. **File System:**
   You can store data as files in the app's sandboxed file system. This can be useful for larger or structured data, such as JSON files or images. Use FileManager to work with the file system.

4. **Core Data:**
   Core Data is a framework for managing a local database on the device. It's suitable for more complex data models and relationships. Core Data can handle queries, sorting, and more advanced data operations.

5. **SQLite:**
   You can use SQLite, a C library, directly or through libraries like FMDB, to create and manage a relational database for offline data storage. It's suitable for applications with more advanced data querying needs.

6. **Realm:**
   Realm is a mobile database that offers an alternative to Core Data and SQLite. It's known for its ease of use, real-time data synchronization, and efficient performance.

7. **Caching:**
   For temporary data storage, you can use caching mechanisms provided by libraries like NSURLCache for HTTP responses or NSCache for general-purpose in-memory caching.

8. **UserDefaults Suites:**
   UserDefaults Suites allow you to store more complex data structures while keeping them organized. It's a way to extend UserDefaults for more structured data storage.

9. **Encrypted Databases:**
   For sensitive data, you can consider using encrypted database libraries that provide built-in encryption features to ensure data security even at rest.

The choice of storage mechanism depends on factors like data complexity, security requirements, performance, and ease of use. You might also use a combination of these options based on different parts of your app's data. Always ensure that you're using the appropriate storage method for the type of data you're handling and consider data protection, data integrity, and user privacy.



# Core Data




## Overview

Use Core Data to save your application’s permanent data for offline use, to cache temporary data, and to add undo functionality to your app on a single device. To sync data across multiple devices in a single iCloud account, Core Data automatically mirrors your schema to a CloudKit container.

Through Core Data’s Data Model editor, you define your data’s types and relationships, and generate respective class definitions. Core Data can then manage object instances at runtime to provide the following features.

[Official Doc](https://developer.apple.com/documentation/coredata)


## Core Data Limitations

Even though Core Data is a fantastic framework, there are several drawbacks. These drawbacks are directly related to the nature of the framework and how it works.

Core Data can only do its magic because it keeps the object graph it manages in memory. This means that it can only operate on records once they’re in memory. This is very different from performing a SQL query on a database. If you want to delete thousands of records, Core Data first needs to load each record into memory. It goes without saying that this results in memory and performance issues if done incorrectly.

Another important limitation is the threading model of Core Data. The framework expects to be run on a single thread. Fortunately, Core Data has evolved dramatically over the years and the framework has put various solutions in place to make working with Core Data in a multithreaded environment safer and easier.

For applications that need to manage a complex object graph, Core Data is a great fit. If you only need to store a handful of unrelated objects, then you may be better off with a lightweight solution or the user defaults system.

[Ref](https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc)






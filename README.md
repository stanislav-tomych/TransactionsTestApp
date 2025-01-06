
# Test Project by Stanislav Tomych

# Overview

This test project was developed by Stanislav Tomych using Swift, UIKit, Combine and Structured Concurrency. The main focus was to create a scalable and maintainable application that not only meets the current requirements but is also easily extensible for future enhancements.

# Technologies and Architecture

 - UIKit: Utilized for building a modern and responsive user interface.
 - Structured Concurrency: Employed to manage asynchronous tasks efficiently.
 - MVVM+C Architecture: Implemented the Model-View-ViewModel+Coordinator pattern for better separation of concerns and testability and clear navigation.
 - Protocol-Oriented Programming: Used to enhance code modularity and reusability.
 - Native URLSession: Leveraged for networking tasks to maintain simplicity and performance.
 - CoreData: To store the transactions locally and have this data between sessions
 
# Project Structure

## Network Layer
The network layer is modularized into several sublayers for clarity and scalability:

 - Endpoints: Defines all API endpoints and handles URL configurations.
 - HTTPRepository: Responsible for making HTTP requests and processing responses.
 - APIService: Manages the interaction with the API, including request preparation and response handling.

## Persistence Layer

The PersistenceService is responsible for managing data storage and retrieval using Core Data. It provides a seamless interface for persisting the app's balance and transaction data, supporting features such as pagination for transactions.

- Balance Management: Stores and retrieves the user's current balance.
- Transaction Management: Saves transactions with attributes like amount, date, category, and type.
- Pagination Support: Fetches transactions in batches with offset and limit parameters for improved performance.
- Core Data Abstraction: Simplifies interactions with Core Data through a centralized service.  
  
## BitcoinRateService
The BitcoinRateService periodically fetches the latest Bitcoin-to-USD exchange rate and provides it to the app. It also caches the most recent rate for offline use.

- Real-Time Updates: Fetches Bitcoin rates every few minutes.
- Caching: Stores the last fetched rate in UserDefaults for offline access.
- Combine Integration: Publishes rate updates using Combine, allowing for reactive UI updates.
- Error Handling: Falls back to the cached rate in case of network issues.
  
## Testing
 - Unit Tests: Comprehensive unit tests cover the Network layer, ViewModels, and Models and Utils to ensure code reliability and facilitate future refactoring.
 
 
# Features

## Screens
 - Transactions Screen:
Displays a paginated list of transactions in a table view.
Each transaction shows the description, amount, and date
The screen includes a section header for each day's transactions and supports pull-to-refresh functionality.
Users can add new transactions or update the balance through dedicated UI actions.
Animations provide smooth updates for both the transaction list and balance changes.
Integrated at the top of the Transactions Screen Bitcoin Rate View, showing the current Bitcoin-to-USD rate.
Updates automatically every few minutes with a fallback to cached rates when offline.
Designed to blend seamlessly with the app's navigation bar for consistent UI aesthetics.

Add Transaction Screen:
Allows the user to input a transaction amount and select a category (e.g., Groceries, Taxi, etc.).
Includes form validation to ensure a valid amount is entered before submission.
On successful submission, the user is redirected back to the Transactions Screen, where the new transaction appears.

## Localization
The app supports three languages:
 - English

## Development Approach

 - Scalability and Extensibility: The project is structured to allow easy addition of new features, functionalities, and network requests with minimal impact on existing code.
 - Clean Code Practices: Emphasized writing clean, readable, and maintainable code throughout the project.

# CurrencyConverterApp
Can get the exchange rates of listed countries.
## Description
1) Get the listed countries code and details from json file.
2) Compare the currency rates in every second.

## Functionality
1) Option to select two countries and can check the exchange rates between them.
2) Option to remove the currency comparision details from the list.
3) Can get the latest exchange rates in every seconds.
4) Stroing the exchange latest rates locally.

## Architecture and Technicalities
1) Used MVVM Design pattern.
2) Used Apple JSON Serialisation to parse JSON Data.
3) Avoid third party frameworks or SDKs use.
4) Used Apple(s) CoreData framework to store (Add, update and remove) the data.
5) Used proper test cases for all the functions.
6) Used Apple network library (because of point no. 3) for API call.
7) Used timer to get all the latest currency exchange rates in every second and storing into DB.

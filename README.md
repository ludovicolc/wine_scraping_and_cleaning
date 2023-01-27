# Projects objective
This project scrapes wine data from an italian website and uses SQL to clean and organize the data.
The final data is stored in a PostgreSQL database and can be used for various wine-related analysis and projects.

## Data
This is an example of raw data:

![Immagine 2023-01-27 095245](https://user-images.githubusercontent.com/105851039/215046621-6b846cd0-176a-49ae-b554-99c220a7e5a9.png)

Brief description of the collected data:
* annata (vintage): year in which the grapes were grown and harvested that were used to make a specific wine.
* denominazione (provenience)
* vitigni (Vines): pure or mixed
* alcol (alcohol): percentage
* allergeni (allergens)
* consumo ideale (Ideal consumption): preferable date for consumption
* temperatura servizio (Serving temperature): Celsius
* abbinamenti (pairings): entrees, meat, fish, cheese... 
* prezzo (price): euro

If you choose to utilize the supplied SQL file for data cleaning and reorganization, the resulting dataset will resemble the following format:

![Immagine 2023-01-27 095317_2](https://user-images.githubusercontent.com/105851039/215048002-40578ce0-e6ab-4407-8e04-3b1e90069856.png)

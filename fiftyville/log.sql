-- Keep a log of any SQL queries you execute as you solve the mystery.

-- PERSONAL NOTES: THEFT TOOK PLACE ON JULY 28,2024. TOOK PLACE ON HUMPHREY STREET

-- I want to see what is on the crime scene reports table
SELECT * FROM crime_scene_reports;

-- Now I want to see the crimes that happened on JULY 28 2024 and on HUMPHREY STREET
-- This query led me to the crime scene report for our crime. It was at the bakery
--      on HUMPHREY STREET at 10:15 am and there are transcripts for the interviews with the 3 witnesses
SELECT * FROM crime_scene_reports
WHERE year = 2024
AND month = 7
AND day = 28
AND street = 'Humphrey Street';

-- Now I want to look into these interview transcripts and see what they say
-- Interviews revealed: Witness 1(RUTH)-within 10 min of theft, thief got in a car in the bakery
--                          parking lot and drove away. check security footage for that time frame;
--                      Witness 2(EUGENE)-recognized thief withdrawing money at ATM on LEGGETT STREET earlier that morning
--                          while walking by
--                      Witness 3(RAYMOND)-saw thief call someone as the thief left the bakery. they talked to
--                          this person on the phone for less than a minute. during call, witness heard the thief
--                          say they were planning to take the earliest flight out of fiftyville tomorrow.
--                          the THIEF ASKED THE PERSON ON THE PHONE TO PURCHASE THE FLIGHT TICKET.
SELECT * FROM interviews
WHERE year = 2024
AND month = 7
AND day = 28;

-- I'll start with the first witnesses info. I need to check security footage for the bakery parking
--  lot during the time frame of the crime.
-- Info wasn't super helpful yet from this,  but I'll come back when I have some other info
SELECT * FROM bakery_security_logs
WHERE year = 2024
AND month = 7
AND day = 28
AND activity = 'exit'
LIMIT 30;

-- Now lets check based on witness 2.
SELECT account_number FROM atm_transactions
WHERE year = 2024
AND month = 7
AND day = 28
AND atm_location = 'Leggett Street'
AND transaction_type = 'withdraw';
-- I want to find the names that correspond with the 8 account numbers I got from the above query
-- I need to join a few tables to access the names of the people whose account numbers I got
-- I got the following names, which are now my suspects
-- SUSPECTS (Bruce, Diana, Brooke, Kenny, Iman, Luca, Taylor, Benista)
SELECT people.name FROM atm_transactions
JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON bank_accounts.person_id = people.id
WHERE year = 2024
AND month = 7
AND day = 28
AND atm_location = 'Leggett Street'
AND transaction_type = 'withdraw'
;

-- Now it is time to check the phone calls and see if we can match any names with our new suspects
-- I'm checking phone calls because of the third witnesses report that the thief called someone while leaving
--      the bakery for LESS THAN A MINUTE. during call, witness heard the thief say they were planning
--      to take the earliest flight out of town tomorrow, and asked the person on the phone to purchase the ticket.
SELECT phone_calls.caller, phone_calls.receiver FROM phone_calls
WHERE year = 2024
AND month = 7
AND day = 28
AND duration < 60
;

-- Now I have a short list of suspect names from the atm, and a short list of phone numbers made which match the
--      reports. I want to compare these two lists and find a possible match.
SELECT people.name, people.phone_number, phone_numbers.caller, phone_numbers.receiver
FROM people
JOIN (
    SELECT people.name FROM atm_transactions
    JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
    JOIN people ON bank_accounts.person_id = people.id
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND atm_location = 'Leggett Street'
    AND transaction_type = 'withdraw'
)
AS suspects ON people.name = suspects.name
JOIN (
    SELECT phone_calls.caller, phone_calls.receiver FROM phone_calls
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND duration < 60
)
AS phone_numbers ON people.phone_number = phone_numbers.caller
;
-- This query above narrowed my suspect list to 5: Bruce, Diana, Kenny, Taylor, Benista
-- Now I want to get these peoples license plate information, so I can check if those plates
--      match up with the bakery's security feed.
SELECT name, license_plate, phone_number FROM people
WHERE name = 'Bruce'
OR name = 'Diana'
OR name = 'Kenny'
OR name = 'Taylor'
OR name = 'Benista'
;

-- I want to create a table called suspects to keep track of some data on my current suspect list
CREATE table suspects (
    person_id INTEGER,
    name TEXT,
    license_plate TEXT,
    phone_number TEXT,
    FOREIGN KEY(person_id) REFERENCES people(id)
);

-- I scrapped the table idea for now but left the query there in case i come back to it

-- I want to  check the license_plate column from bakery_security_logs for license_plates from my suspects
SELECT b.license_plate, p.name
FROM bakery_security_logs b
JOIN people p ON b.license_plate = p.license_plate
WHERE p.name IN ('Bruce', 'Diana', 'Kenny', 'Taylor', 'Benista')
AND year = 2024
AND month = 7
AND day = 28
AND activity = 'exit';
--This narrowed it down to three suspects (Bruce, Diana, Taylor)
-- SUSPECT INFO: (NAME: Bruce, LICENSE PLATE: 94KL13X, PHONE NUMBER: (367) 555-5533)
--               (NAME: Diana, LICENSE PLATE: 322W7JE, PHONE NUMBER: (770) 555-1861)
--               (NAME: Taylor, LICENSE PLATE: 1106N58, PHONE NUMBER: (286) 555-6063)

-- Taking a break for the night. Current idea for next step is to check the passport number for each
--      of my three suspects, then check that against the passport number of flights the day after the
--      murder. I think I will need to join people with passengers on passport number
--      and join passengers with flights on flight_id. This should allow me to check for those passport
--      numbers on flights the day after the murder. Hopefully this narrows it to one suspect, surely.
--      If that doesnt work, I can try to check the receiver phone numbers from my three suspects and see if those
--      phone numbers bought a flight for the day after the crime. If only one bought a flight, we know
--      thats our 'guy' because the call receiver was supposed to buy the thiefs flight ticket for the next day.

-- Query to get passports numbers of suspects, along with a bit of other relevant info
SELECT passport_number, name, phone_number
FROM people
WHERE people.name
IN ('Bruce','Diana','Taylor')
ORDER BY name ASC
;

-- Now I need to find the airport id for fiftyville airport
SELECT full_name, city, id
FROM airports
LIMIT 30
;
-- From this query I was able to determine the fiftyville airport id is 8

-- Now lets check the earliest flight from fiftyville on July 29 2024
SELECT * FROM flights
WHERE origin_airport_id = 8
AND year = 2024
AND month = 7
AND day = 29
;
-- From this we found out the earliest flight out of fiftyville on July 29 was at 8:20 am, went to
-- destination_airport_id 4, and the flight id was 36

-- Now we check flight_id 36 in the PASSENGERS table for passport numbers matching the suspects passport numbers
SELECT p.passport_number, p.name, pa.flight_id, f.year, f.month, f.day, f.hour, f.minute FROM people p
JOIN passengers pa ON p.passport_number = pa.passport_number
JOIN flights f ON pa.flight_id = f.id
WHERE pa.flight_id = 36
AND f.year = 2024
AND f.month = 7
AND f.day = 29
AND f.hour = 8
AND f.minute = 20
AND p.name IN ('Bruce','Taylor','Diana')
;
-- From this I now know that only Bruce and Taylor were on that earliest flight from fiftyville
-- the day after the murder. I am going to check how their tickets were bought, and check if
-- their ticket was bought by the receiver of their matching phone call from the crime scene

-- I used some older queries from above to get license plate info from the bakery security logs
-- that exited the bakery within the 10 minute window of the robbery, which a witness saw happen.
-- The other query was just for the license plates of the suspects.
SELECT * FROM bakery_security_logs
WHERE year = 2024
AND month = 7
AND day = 28
AND activity = 'exit'
LIMIT 30;

SELECT name, license_plate, phone_number FROM people
WHERE name = 'Bruce'
OR name = 'Diana'
OR name = 'Kenny'
OR name = 'Taylor'
OR name = 'Benista'
;
-- Only Bruce's license plate matched, making him the only remaining suspect who can be placed
-- at the crime scene, leaving, during the witnesses time. I'm now going to check where his flight landed
-- and who received his phone call while leaving the bakery, because we know the receiver of that call booked
-- his flight to get him out of town.
SELECT * FROM flights
WHERE origin_airport_id = 8
AND year = 2024
AND month = 7
AND day = 29
;
-- I checked this old query to find that the destination_airport_id for the thiefs flight is 4

SELECT full_name, city, id
FROM airports
LIMIT 30
;
-- I checked the name of the airport with the id of 4 and it was LaGuardia Airport in NYC.

SELECT people.name, people.phone_number, phone_numbers.caller, phone_numbers.receiver
FROM people
JOIN (
    SELECT people.name FROM atm_transactions
    JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
    JOIN people ON bank_accounts.person_id = people.id
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND atm_location = 'Leggett Street'
    AND transaction_type = 'withdraw'
)
AS suspects ON people.name = suspects.name
JOIN (
    SELECT phone_calls.caller, phone_calls.receiver FROM phone_calls
    WHERE year = 2024
    AND month = 7
    AND day = 28
    AND duration < 60
)
AS phone_numbers ON people.phone_number = phone_numbers.caller
;
-- I checked the receiver's number of Bruce's call using another previous query for my 5 suspects at the time
-- the receivers number = (375) 555-8161. Lets check for the name that corresponds
SELECT name FROM people
WHERE phone_number = '(375) 555-8161'
;

-- Robin is the name, so this was Bruce's accomplice. Bruce flew to NYC.

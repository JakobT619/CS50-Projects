from cs50 import get_float

# Ask user for the change owed
while True:
    change = get_float("Change owed: ")
    if change > 0:
        break
    print("Invalid input. Enter a positive number.")


def get_coins(change):
    # Convert dollars to cents to avoid floating point imprecision
    cents = round(change * 100)

    # Make a list to define the coin values
    coins = [25, 10, 5, 1]

    # Create counter for the number of coins
    num_coins = 0

    # Loop through each coin
    for coin in coins:
        num_coins += cents // coin   # Increment the number of coins for that coin type
        cents %= coin   # Update the remaining cents each time through the loop

    return num_coins


# Use the get_coins function to get the total number of coins given as change
coins = get_coins(change)

# Print output of total coins
print(f"Total Coins: {coins}")

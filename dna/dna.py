import sys
import csv


def main():

    # TODO: Check for command-line usage
    if len(sys.argv) != 3:
        print("Usage: python dna.py data.csv sequence.txt")
        sys.exit(1)

    # TODO: Read database file into a variable
    filename = sys.argv[1]
    data = read_csv(filename)

    # TODO: Read DNA sequence file into a variable
    filename = sys.argv[2]
    sequence = read_sequence(filename)

    # TODO: Create a list of subsequences to be checked
    subsequences = list(data[0].keys())[1:]

    # TODO: Find and store the results for longest match of each STR in a dict, longest_runs
    longest_runs = {}
    for subsequence in subsequences:
        longest_runs[subsequence] = longest_match(sequence, subsequence)

    # TODO: Check database for matching profiles
    for person in data:
        match = True
        for subsequence in subsequences:
            if int(person[subsequence]) != longest_runs[subsequence]:
                match = False
                break
        if match:
            print(f"{person['name']}")
            break
    else:
        print("No Match.")


def read_csv(filename):

    try:
        with open(filename, "r") as csv_file:
            reader = csv.DictReader(csv_file)
            rows = []
            for row in reader:
                rows.append(row)
        return rows
    except FileNotFoundError:
        print("Error: Could not open file")


def read_sequence(filename):

    try:
        with open(filename, "r") as dna_file:
            sequence = dna_file.read().strip()
        return sequence
    except FileNotFoundError:
        print("Error: Could not open file")


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()

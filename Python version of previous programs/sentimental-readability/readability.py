def main():

    # Prompt user to input a text
    s = input("Text: ")

    # Call the calc function to obtain the reading level index
    index = calculate_reading_level(s)

    # Call the print function to give the user the reading level
    print_reading_level(index)


# Function that takes a piece of text as input, and returns the letter count for that text
def get_letter_count(s):

    # Create a counter for the number of letters
    letters = 0

    # Loop through each character in the text s
    for c in s:
        # Check whether the character is a letter
        if c.isalpha():
            letters += 1  # If it a is a letter, increment the letter counter by 1

    return letters

# Function that takes a piece of text as input, and returns the word count for that text
def get_word_count(s):

    # Create a counter for words
    words = 1

    # Loop though each character in text s
    for c in s:
        # Check whether the character is a space
        if c.isspace():
            words += 1

    return words

# Function that takes a piece of text as input, and returns the sentence count for that text
def get_sentence_count(s):

    # Create a counter for sentences
    sentences = 0

    # Loop through each character in test s
    for c in s:
        # Check whether the character is punctuation
        if c in '.?!':
            sentences += 1

    return sentences

 # Function that takes a piece of text as input, and returns the index for reading level
def calculate_reading_level(s):

    letters = get_letter_count(s)

    words = get_word_count(s)

    sentences = get_sentence_count(s)

    L = letters / words * 100
    S = sentences / words * 100

    index = round(0.0588 * L - 0.296 * S - 15.8)

    return index

# Function that prints the reading level based on the index from the calculate function
def print_reading_level(index):

    if index < 1:
        print("Reading level: Before Grade 1")

    elif index > 16:
        print("Reading level: Grade 16+")

    else:
        print(f"Reading level: Grade {index}")


main()



def read_csv(argv[0]):
    try:
        with open('csv_file', 'r') as file:
            reader = csv.DictReader(file)
            print(reader.fieldnames)
        return reader
    except FileNotFoundError:
        print("Error: Could not open file")

    row = []
    with open('csv_file', 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
                rows.append(row)

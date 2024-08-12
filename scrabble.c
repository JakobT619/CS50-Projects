#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

// Points assigned to each letter of the alphabet
int POINTS[26] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};

// Define a function called 'compute_score' that takes a string called word and returns the word's score as an int
int compute_score(string word);

int main(void)
{
    // Prompt the user for two words
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    int score1 = compute_score(word1);
    int score2 = compute_score(word2);

    // Print the winner
    if (score1 > score2)
    {
        printf("Player 1 Wins!\n");
    }
    else if (score1 < score2)
    {
        printf("Player 2 Wins!\n");
    }
    else
    {
        printf("Tie!\n");
    }
}
int compute_score(string word)
{
    // Compute the score of each world   //word[i] is my array for the location within each word (word[0] is the first letter in my word,and so on)
    // POINTS[word[i] - 'A'] means it is getting the point value for each letter in 'word' one letter at a time. A is subtracted because the index of a letter in 'word' can be found by subtracting 65 from each letters ascii value. this 65 comes from the ascii value for 'A' for upper case. same logic applies to islower, but you subtract the value of 'a'.
    int score = 0;

    for (int i = 0; i < strlen(word); i++)
    {
        if (isupper(word[i]))
        {
            score = score + POINTS[word[i] - 'A'];
        }
        if (islower(word[i]))
        {
            score = score + POINTS[word[i] - 'a'];
        }
    }
    return score;
}

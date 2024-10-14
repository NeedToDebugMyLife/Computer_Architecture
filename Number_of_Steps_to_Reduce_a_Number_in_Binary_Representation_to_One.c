#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

static inline int my_clz(uint32_t x)
{
    int count = 0;
    for (int i = 31; i >= 0; --i)
    {
        if (x & (1U << i))
            break;
        count++;
    }
    return count;
}

static inline int reduce2one(uint32_t num)
{
    int steps = 0;
    int zeros = my_clz(num);

    if (zeros == 32)
        return -1;
    
    if (zeros == 31)
        return 0;

    int times = 32 - zeros;
    for(int i=0; i < times; i++)
    {
        if ((num & 0x1))
        {
            if (num != 1)
            {
                num++;
                steps += 2;
            }
        }
        else
            steps++;

        num = num >> 1;

        if (i+1==times && num != 1)
        {
            i = 0;
            times = 32 - my_clz(num);
        }
    }
    return steps;
}

static inline uint32_t bin2num(int num)
{
    int i = 0;
    uint32_t bin = 0;
    while (num != 0)
    {
        if (num % 10 == 1)
        {
            bin += pow(2, i);
        }
        i++;
        num /= 10;
    }
    return bin;
}


int main(void)
{
    char s1[] = "10101011";
    uint32_t num1 = bin2num(atoi(s1));
    if (reduce2one(num1) == 12)
        printf("Test 1: Result correct.\n");
    else
        printf("Test 1: Result wrong.\n");

    char s2[] = "1101";
    uint32_t num2 = bin2num(atoi(s2));
    if (reduce2one(num2) == 6)
        printf("Test 2: Result correct.\n");
    else
        printf("Test 2: Result wrong.\n");

    char s3[] = "10";
    uint32_t num3 = bin2num(atoi(s3));
    if (reduce2one(num3) == 1)
        printf("Test 3: Result correct.\n");
    else
        printf("Test 3: Result wrong.\n");

    char s4[] = "1";
    uint32_t num4 = bin2num(atoi(s4));
    if (reduce2one(num4) == 0)
        printf("Test 4: Result correct.\n");
    else
        printf("Test 4: Result wrong.\n");

    return 0;
}
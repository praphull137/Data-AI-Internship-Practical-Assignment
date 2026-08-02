# Solution Notes

## Environment
- Python version:
- Key libraries used:
- LLM API used:
- LLM model used:

## Highest Level Completed

_Mark which level you reached per exercise:_

| Exercise | BASE | STANDARD | ADVANCED |
|----------|------|----------|----------|
| 1 - Python & Data | [x ] | [x ] | [ ] |
| 2 - SQL | [x ] | [x ] | [ ] | Got Query 7 working
, didn't get to 8 or 9
| 3 - LLM | [x ] | [ ] | [ ] |
| 4 - Integration | [ x] | [ ] | [ ] |

---

## Exercise 1: Data Handling

**Your approach:** _Describe what you did and why._
I got through BASE and STANDARD. For BASE I used the csv module's
DictReader instead of manually splitting on commas, so I didn't have to worry about commas showing up inside text fields breaking my parsing. For STANDARD I switched to pandas for the cleaning and aggregation - filtering
out empty descriptions, lowercasing priority, parsing dates, then using groupby for the monthly counts and average resolution time.

I did not get to ADVANCED (chunked loading, anomaly detection, summary report). I
wanted to make sure BASE and STANDARD were solid first, and I honestly wasn't
confident yet on how to approach detecting things like "resolved before created" cleanly, or how chunked reading with chunksize actually works under the hood, so I ran out of time before getting to it properly. If I came back to it, my intention would be to compare resolved at and created at directly per row for the impossible-date check, and use pandas' duplicated() for the duplicate-title check rather than writing nested loops.

**If you completed BASE:** What was your strategy for handling the messy priority values (mixed case like "HIGH", "high", "High")? Did you use any specific Python technique?

My strategy for the mixed-case priority values ("HIGH", "high",
"High") was lowercasing both sides before comparing them: row_priority.lower() ==
priority.lower(). Python string comparison is case-sensitive by default, so with
out this,"High" and "high" would be treated as completely different values.

**If you completed STANDARD:** What would you change if this dataset had 1 million rows instead of 35?

If this dataset had 1 million rows instead of 35, loading the whole thing into memory with pd.readcsv() in one go could get slow or use a lot of
memory. I know pandas has a chunksize option for read_csv that lets you process a file in smaller pieces instead of all at once, though I didn't actually get to implement that myself(that's the ADVANCED level's load data chunked function, which I didn't finish).

**If you completed ADVANCED:** How did you decide what counts as an "anomaly"? Where do you draw the line between messy data and actually wrong data?

Didn't get here yet.
---

## Exercise 2: SQL

**Your approach:** _Describe what you did and why._


I worked through BASE, STANDARD, and made it partway into ADVANCED - I got Query 7 (recently hired employees in departments with a completed project) working using a subquery,but I didn't manage Query 8 (project success rate
ranking) or Query 9 (highest-paid employee per department with ties) in time. Query 9 inparticular felt like it needed a technique I hadn't worked with
yet, since just grouping and using
MAX() doesn't cleanly give you back the matching employee row.

**If you completed BASE:** Which query was hardest to write and what did you look up or try before getting it right?

Query 3 (count employees per department, including departments with zero employees) took me the longest to get right. My first instinct was a
regular JOIN and it just silently left out departments with no employees at all, no error,just an incomplete result took me a bit to notice. Switching to LEFT JOIN starting from departments fixed it.

**If you completed STANDARD:** In Query 6 (active projects per department), how did you handle departments with zero projects? What happens if you use INNER JOIN instead?

For Query 6, I used LEFT JOIN starting from departments so every department shows up even with zero active projects, and I put the status ='active' condition inside the JOIN's ON clause so it only counts active ones without
dropping the whole department if it has no active projects. If I used INNER JOIN instead,any department with zero matching project rows would disappear from the results entirely,which breaks the "include zero" requirement.

**If you completed ADVANCED:** Query 9 (highest salary per department with ties) — what approach did you take, and what's an alternative way to solve it?

I only got Query 7 done, not Query 8 or 9, so I don't have a real answer for the "highest salary per department with ties" approach question. My
guess/intention if I went back to it would be something involving comparing each
employee's salary to the MAX() salary within their own department,but I hadn't worked out the exact syntax for that when I stopped.
---

## Exercise 3: LLM & Prompt Engineering

**Your approach:** _Describe what you did and why._

I only got through BASE for this one. I wrote prompts for summarizing text,
classifying sentiment as one word, and answering a question based only on the given text. I didn't get to STANDARD (structured JSON extraction, comparing two prompt strategies) or ADV ANCED (retry logic, validation, cost estimation) - the JSON extraction part especially felt like a bigger jump since I'd need to actually get the model to reliably return parseable JSON, and I wasn't sure how to
handle it if the model added extra text around the JSON.

**If you completed BASE:** What did you notice about how the LLM responds differently when you change the wording of your prompt? Give a specific example.

The biggest thing I noticed is that without being specific about the
output format, the model tends to explain itself instead of just answering. For sentiment, if I'd just asked "what's the sentiment of this text?" I'd probably get a full sentence back. Being explicit — "reply with
only one word: positive, neutral, or negative, nothing else" — is what actually g
ot me a clean one-word answer.

**If you completed STANDARD:** Which of your two prompt strategies worked better? Paste both prompts here and explain what specifically made the difference.

Not reached till here.
**If you completed ADVANCED:** How does your retry logic decide when to give up? What's the worst-case scenario for your error handling?
Did not get it.
---

## Exercise 4: Integration

**Your approach:** _Describe what you did and why._

I only completed BASE. I read all the .txt files from the folder, counted
words, pulled out the most frequent non-stop-words as simple keywords, and computed basic stats (total docs, total words, average, shortest/longest doc). I didn't get to STANDARD (LLM-based summary/keyword/sentiment analysis, saving to JSON,generating a report) or ADV ANCED (fault-tolerant processing, incremental/resumable processing, comparison report) - by this point in the exercises I was running low on timeand the LLM-integration parts across exercises 3 and 4 both
felt like the biggest jump from what I'd done before.

**If you completed BASE:** How did you handle stop-word removal in keyword extraction? What list did you use and would you change it?

For stop-word removal I hardcoded a set of common English stop words (the, a, is, in, of, and, to, for, etc.) and filtered them out after lowercasing everything
and stripping punctuation off each word. I'd probably change this if I had more time since my list definitely isn't complete - a proper library like nltk 's stop word list would likely catch more than my manual set did.

**If you completed STANDARD:** If one document fails during LLM processing, does your pipeline stop or continue? Paste the specific code that handles this.

Didn't get here yet

**If you completed ADVANCED:** How does your incremental processing detect which documents were already processed? What happens if the output file gets corrupted?

Didn't get here yet
---

## Process Questions

_These questions are about your experience doing the task, not the code itself._

1. **What did you get stuck on longest?** Describe the specific moment — what you were trying to do, what went wrong, and how you got past it.

Two things took me the longest. First, working with data/file handling in Exercise 1 which is reading the CSV, handling messy values, and later doing the pandas cleaning and date parsing in STANDARD - since that whole area of loading and cleaning real-world data wasn't something I'd done much of before. Second, LLMs and prompt engineering in general - I'm still fairly new to this area, so before I could even attempt the STANDARD/ADVANCED level functions for Exercises 3 and 4, I spent a good chunk of time just studying what prompting techniques like few-shot examples and format constraints actually do and why they help, rather than jumping straight into writing code I didn't understand.

2. **What did you Google/search for during this task?** List 2–3 specific things you looked up.

i looked for python csv DictReader example, pandas groupby datetime by month, sqlite left join count zero rows, what is few-shot prompting.

3. **If you used AI tools (Copilot, ChatGPT, etc.), which parts did you use them for?** Be honest — this is not penalized. We want to understand your workflow.

I used Claude and ChatGPT throughout this task, mainly as a teaching tool rather than to write code I didn't understand. My background is Java, C, and C++, not Python, so I used it to explain Python syntax and pandas concepts I hadn't used before, walk through why certain approaches were correct (like using LEFT JOIN instead of INNER JOIN, or lowercasing before comparing strings), and to help me study the LLM/prompt engineering concepts I was weakest on. I made sure I could explain the logic myself afterward rather than just copying working code.
---

## Self-Estimation


_Rate your current skill level honestly (1 = no experience, 5 = very confident):_

| Skill | 1 | 2 | 3 | 4 | 5 |
|-------|---|---|---|---|---|
| Python programming | [ ] | [ ] | [ x] | [ ] | [ ] |
| Working with data (files, CSV, JSON) | [ ] | [x ] | [ ] | [ ] | [ ] |
| pandas / data analysis | [ ] | [x ] | [ ] | [ ] | [ ] |
| SQL | [ ] | [ ] | [ ] | [x ] | [ ] |
| Git and version control | [ ] | [ ] | [ ] | [x ] | [ ] |
| REST APIs (calling/building) | [ ] | [ ] | [x ] | [ ] | [ ] |
| LLMs and prompt engineering | [ ] | [x ] | [ ] | [ ] | [ ] |
| Error handling and debugging | [ ] | [ ] | [ ] | [x ] | [ ] |
| Reading documentation to learn new tools | [ ] | [ ] | [ ] | [x ] | [ ] |
| Explaining technical concepts to others | [ ] | [ ] | [ ] | [x ] | [ ] |

**What is your strongest technical skill overall?**
_
SQL because I studied it in a university class and got a 10/10 grade, and it also came through directly in this assignment, where I got 7 of 9 queries working correctly, including JOINs, aggregations, and subqueries.

**What is the area you most want to improve during the bootcamp?**
_

LLMs and prompt engineering, and REST APIs - these are the areas I'm currently weakest in, and also exactly what this internship is centered around, so I want to close that gap specifically.

**Have you built any personal or work projects before? If yes, briefly describe one:**
_

I wanted to build something practical that solves a real-world problem. Fake news spreads quickly online, so I thought it would be useful to create a tool that not only classifies news but also explains the reasoning behind the result.The Baltic See is a web application I built to help users check whether a news article, photos are likely to be true or fake. The user enters a news article or a news link, and the application analyzes it through a multi-step verification process. Instead of only giving a "fake" or "true" label, it also provides supporting evidence and sources so the user can understand why it reached that conclusion. The application also displays a feed of recent real and fake news examples to help users compare different types of news. I built this project to learn more about web development, APIs, and AI-powered information verification It's currently a prototype: https://baltic-sea-news.vercel.app/
---

## Self-Assessment

_What are you least confident about in your submission? What would you do differently next time?_

I'm least confident about the LLM/prompt engineering and REST API sections of this submission - Exercises 3 and 4 only reached BASE level, and that's a direct reflection of where I'm currently weakest, not a lack of effort. I spent real time studying what prompting techniques like few oneshot examples and explicit format constraints actually do before I felt ready to write STANDARD level code around them, and I ran out of time before getting there. SQL and the pandas-based data handling in Exercise 1 are where I feel most solid, since I got hands-on with LEFT JOIN vs INNER JOIN behavior, subqueries, and groupby/date logic and could work through the edge cases myself.

What I'd do differently next time is to start the LLM exercises earlier instead of later, since they turned out to be my biggest knowledge gap, and budget dedicated study time for prompt engineering concepts before attempting the code, rather than treating it as just another exercise alongside the others.
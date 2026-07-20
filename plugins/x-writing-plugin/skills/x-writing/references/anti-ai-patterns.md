# Anti-AI Patterns — X Writing Reference

Based on the humanizer skill (v2.5.1) and Wikipedia's "Signs of AI writing" guide.
Load this file when humanizing text or running the final anti-AI pass.

---

## Quick kill list — scan for these first

Words that instantly mark AI authorship. Replace or cut every instance.

**AI vocabulary (high-frequency):**
actually, additionally, align with, crucial, delve, emphasizing, enduring, enhance,
fostering, garner, highlight (verb), interplay, intricate/intricacies, key (adjective),
landscape (abstract noun), pivotal, showcase, tapestry (abstract noun), testament,
underscore (verb), valuable, vibrant

**Copula avoidance — replace with is/are/has:**
serves as, stands as, marks (as a role), represents (as equivalent), boasts, features, offers

**Filler phrases — delete or compress:**
- "In order to achieve" → "To achieve"
- "Due to the fact that" → "Because"
- "At this point in time" → "Now"
- "In the event that" → "If"
- "Has the ability to" → "Can"
- "It is important to note that" → (just state the thing)
- "Let's dive into" → (just start)
- "Here's what you need to know" → (just say it)

---

## 29 patterns — full checklist

### CONTENT PATTERNS

**1. Significance inflation**
Puffing up importance with words like: stands/serves as, testament, vital/pivotal/crucial role,
underscores/highlights its importance, reflects broader, symbolizing enduring, setting the stage,
marks a shift, key turning point, evolving landscape, indelible mark.

Before: "marking a pivotal moment in the evolution of software development"
After: "changed how developers write boilerplate"

**2. Notability name-dropping**
Listing publications/follower counts as proof of credibility without context.
Before: "cited in NYT, BBC, FT. 500K followers."
After: "In a 2024 NYT interview, she argued..."

**3. Superficial -ing analyses**
Tacking -ing phrases onto sentences to fake depth: highlighting, underscoring, emphasizing,
reflecting, symbolizing, contributing to, fostering, encompassing, showcasing.
Before: "symbolizing Texas bluebonnets, reflecting the community's connection to the land"
After: Cut entirely or expand with a real source.

**4. Promotional language**
Neutral tone breaks down on "cultural" or emotional topics.
Kill: boasts, vibrant, rich (figurative), profound, enhancing its, showcasing, nestled,
in the heart of, groundbreaking, renowned, breathtaking, stunning, must-visit.

**5. Vague attributions**
"Experts argue," "Industry reports," "Observers have cited," "Some critics argue."
Always name the specific source or remove the attribution.

**6. Formulaic challenges sections**
"Despite [challenges]... continues to thrive."
Replace with specific facts about the actual challenges.

---

### LANGUAGE PATTERNS

**7. AI vocabulary** — see quick kill list above.

**8. Copula avoidance** — "serves as / features / boasts" instead of "is / has."
Before: "Gallery 825 serves as LAAA's exhibition space and boasts 3,000 sq ft."
After: "Gallery 825 is LAAA's exhibition space with 3,000 sq ft."

**9. Negative parallelisms + tailing negations**
"It's not just about X; it's Y" → just state Y.
Tailing negations: "The options come from the item, no guessing." → "...without forcing a guess."

**10. Rule of three overuse**
AI forces ideas into threes to appear comprehensive. Use the natural number of items.
Before: "innovation, inspiration, and industry insights"
After: "talks and panels. Also time for networking."

**11. Synonym cycling (elegant variation)**
AI avoids repetition by cycling synonyms: protagonist / main character / central figure / hero.
Use the clearest noun and repeat it. Repetition is fine.

**12. False ranges**
"From X to Y, from A to B" where X/Y aren't on a meaningful scale.
Before: "from the Big Bang to dark matter"
After: List the topics directly.

**13. Passive voice + subjectless fragments**
"No configuration file needed." → "You don't need a configuration file."
Name the actor when it helps clarity.

---

### STYLE PATTERNS

**14. Em dash overuse (—)**
LLMs use em dashes to mimic punchy writing. In X posts: never use them.
Replace with a comma, period, or parentheses.

**15. Boldface overuse**
In tweets: no bold. In long-form: bold only for genuine emphasis, not decoration.
Before: "It blends **OKRs**, **KPIs**, and **BMC**."
After: "It blends OKRs, KPIs, and BMC."

**16. Inline-header bullet lists**
"**Performance:** Performance improved." → Rewrite as prose or remove the inline header.

**17. Title Case headings**
Use sentence case everywhere. "Strategic Negotiations And Partnerships" → "Strategic negotiations and partnerships."

**18. Emojis as decoration**
In tweets: one emoji (🧵) at the end of the hook is fine. Decorative emojis on bullets → remove.

**19. Curly quotation marks**
"like this" → use straight quotes "like this"

**26. Hyphenated word pair overuse**
AI consistently hyphenates: cross-functional, data-driven, client-facing, decision-making,
high-quality, real-time, long-term. Humans are inconsistent. Drop the hyphens on common pairs.

**27. Persuasive authority tropes**
"The real question is," "At its core," "In reality," "What really matters," "The deeper issue."
These pretend to cut to truth but usually just restate something obvious.
Before: "At its core, what really matters is organizational readiness."
After: "The question is whether the organization is ready to change its habits."

**28. Signposting announcements**
"Let's dive in," "Let's explore," "Without further ado," "Here's what you need to know."
Cut them. Start with the content.
Before: "Let's dive into how caching works in Next.js."
After: "Next.js caches data at multiple layers..."

**29. Fragmented headers**
A heading followed by a one-line warm-up that just restates the heading.
Before: "## Performance\n\nSpeed matters.\n\nWhen users hit a slow page, they leave."
After: "## Performance\n\nWhen users hit a slow page, they leave."

---

### COMMUNICATION PATTERNS

**20. Chatbot artifacts**
"I hope this helps!", "Of course!", "Certainly!", "Would you like me to...", "Let me know if..."
Delete entirely.

**21. Knowledge-cutoff disclaimers**
"As of my last training update," "While specific details are limited..."
Remove or replace with a real source.

**22. Sycophantic tone**
"Great question!", "You're absolutely right!", "That's an excellent point!"
Before: "Great question! You're right that this is complex."
After: "The economic factors you mentioned are relevant here."

---

### FILLER + HEDGING

**23. Filler phrases** — see quick kill list above.

**24. Excessive hedging**
"Could potentially possibly be argued that might have some effect."
Keep one hedge max. "The policy may affect outcomes."

**25. Generic positive conclusions**
"The future looks bright. Exciting times lie ahead."
Replace with a specific next action or concrete fact.

---

## Final audit pass

After rewriting, run this check internally:

Ask: "What makes this so obviously AI-generated?"
List the remaining tells (brief bullets).
Then fix them.

Signs of soulless writing (even if technically "clean"):
- Every sentence is the same length and structure
- No opinions, just neutral reporting
- No first-person perspective when appropriate
- No acknowledgment of mixed feelings or uncertainty
- Reads like a Wikipedia article or press release

How to add soul:
- **Have opinions.** "I genuinely don't know how to feel about this" beats neutrally listing pros/cons.
- **Vary rhythm.** Short punchy sentences. Then longer ones that take their time.
- **Acknowledge complexity.** "This is impressive but also kind of unsettling."
- **Use "I" when it fits.** "I keep coming back to..." signals a real person thinking.
- **Be specific about feelings.** Not "this is concerning" but "there's something unsettling about X."
- **Let some mess in.** Perfect structure feels algorithmic.

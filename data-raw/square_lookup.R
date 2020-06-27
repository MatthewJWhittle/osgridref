## code to prepare `DATASET` dataset goes here

rm(list = ls())

require(tidyverse)

string <- "HL
0 12	HM
1 12	HN
2 12	HO
3 12	HP
4 12	JL
5 12	JM
6 12	JN
7 12
HQ
0 11	HR
1 11	HS
2 11	HT
3 11	HU
4 11	JQ
5 11	JR
6 11	JS
7 11
HV
0 10	HW
1 10	HX
2 10	HY
3 10	HZ
4 10	JV
5 10	JW
6 10	JX
7 10
NA
09	NB
19	NC
29	ND
39	NE
49	OA
59	OB
69	OC
79
NF
08	NG
18	NH
28	NJ
38	NK
48	OF
58	OG
68	OH
78
NL
07	NM
17	NN
27	NO
37	NP
47	OL
57	OM
67	ON
77
NQ
06	NR
16	NS
26	NT
36	NU
46	OQ
56	OR
66	OS
76
NV
05	NW
15	NX
25	NY
35	NZ
45	OV
55	OW
65	OX
75
SA
04	SB
14	SC
24	SD
34	SE
44	TA
54	TB
64	TC
74
SF
03	SG
13	SH
23	SJ
33	SK
43	TF
53	TG
63	TH
73
SL
02	SM
12	SN
22	SO
32	SP
42	TL
52	TM
62	TN
72
SQ
01	SR
11	SS
21	ST
31	SU
41	TQ
51	TR
61	TS
71
SV
00	SW
10	SX
20	SY
30	SZ
40	TV
50	TW
60	TX
70"

tokens <- string %>% str_split("\t|\n") %>% unlist()

letters <- tokens[seq(1, length(tokens), by = 2)]
numbers <- tokens[seq(2, length(tokens), by = 2)]

xy  <- case_when(nchar(numbers) == 2 ~ str_split(numbers, n = 2, pattern = ""),
                 nchar(numbers) > 2 ~ str_split(numbers, n = 2, pattern = " "),
) %>% lapply(as.numeric)

xy <- do.call(rbind, xy)

colnames(xy) <- c("x", "y")

square_lookup <- as_tibble(xy) %>% mutate(square_letters = letters)


usethis::use_data(square_lookup, overwrite = TRUE)

---
title: "Final Code Document"
output: html_document
---
 ## Cleaning



```
## # A tibble: 8,315 × 195
##      iid    id gender   idg condtn  wave round position positin1 order partner
##    <dbl> <dbl>  <dbl> <dbl>  <dbl> <dbl> <dbl>    <dbl>    <dbl> <dbl>   <dbl>
##  1     1     1      0     1      1     1    10        7       NA     4       1
##  2     1     1      0     1      1     1    10        7       NA     3       2
##  3     1     1      0     1      1     1    10        7       NA    10       3
##  4     1     1      0     1      1     1    10        7       NA     5       4
##  5     1     1      0     1      1     1    10        7       NA     7       5
##  6     1     1      0     1      1     1    10        7       NA     6       6
##  7     1     1      0     1      1     1    10        7       NA     1       7
##  8     1     1      0     1      1     1    10        7       NA     2       8
##  9     1     1      0     1      1     1    10        7       NA     8       9
## 10     1     1      0     1      1     1    10        7       NA     9      10
## # ℹ 8,305 more rows
## # ℹ 184 more variables: pid <dbl>, match <dbl>, int_corr <dbl>, samerace <dbl>,
## #   age_o <dbl>, race_o <dbl>, pf_o_att <dbl>, pf_o_sin <dbl>, pf_o_int <dbl>,
## #   pf_o_fun <dbl>, pf_o_amb <dbl>, pf_o_sha <dbl>, dec_o <dbl>, attr_o <dbl>,
## #   sinc_o <dbl>, intel_o <dbl>, fun_o <dbl>, amb_o <dbl>, shar_o <dbl>,
## #   like_o <dbl>, prob_o <dbl>, met_o <dbl>, age <dbl>, field <chr>,
## #   field_cd <dbl>, undergra <chr>, mn_sat <dbl>, tuition <dbl>, race <dbl>, …
```

```
##   [1] "iid"      "id"       "gender"   "idg"      "condtn"   "wave"
##   [7] "round"    "position" "positin1" "order"    "partner"  "pid"
##  [13] "match"    "int_corr" "samerace" "age_o"    "race_o"   "pf_o_att"
##  [19] "pf_o_sin" "pf_o_int" "pf_o_fun" "pf_o_amb" "pf_o_sha" "dec_o"
##  [25] "attr_o"   "sinc_o"   "intel_o"  "fun_o"    "amb_o"    "shar_o"
##  [31] "like_o"   "prob_o"   "met_o"    "age"      "field"    "field_cd"
##  [37] "undergra" "mn_sat"   "tuition"  "race"     "imprace"  "imprelig"
##  [43] "from"     "zipcode"  "income"   "goal"     "date"     "go_out"
##  [49] "career"   "career_c" "sports"   "tvsports" "exercise" "dining"
##  [55] "museums"  "art"      "hiking"   "gaming"   "clubbing" "reading"
##  [61] "tv"       "theater"  "movies"   "concerts" "music"    "shopping"
##  [67] "yoga"     "exphappy" "expnum"   "attr1_1"  "sinc1_1"  "intel1_1"
##  [73] "fun1_1"   "amb1_1"   "shar1_1"  "attr4_1"  "sinc4_1"  "intel4_1"
##  [79] "fun4_1"   "amb4_1"   "shar4_1"  "attr2_1"  "sinc2_1"  "intel2_1"
##  [85] "fun2_1"   "amb2_1"   "shar2_1"  "attr3_1"  "sinc3_1"  "fun3_1"
##  [91] "intel3_1" "amb3_1"   "attr5_1"  "sinc5_1"  "intel5_1" "fun5_1"
##  [97] "amb5_1"   "dec"      "attr"     "sinc"     "intel"    "fun"
## [103] "amb"      "shar"     "like"     "prob"     "met"      "match_es"
## [109] "attr1_s"  "sinc1_s"  "intel1_s" "fun1_s"   "amb1_s"   "shar1_s"
## [115] "attr3_s"  "sinc3_s"  "intel3_s" "fun3_s"   "amb3_s"   "satis_2"
## [121] "length"   "numdat_2" "attr7_2"  "sinc7_2"  "intel7_2" "fun7_2"
## [127] "amb7_2"   "shar7_2"  "attr1_2"  "sinc1_2"  "intel1_2" "fun1_2"
## [133] "amb1_2"   "shar1_2"  "attr4_2"  "sinc4_2"  "intel4_2" "fun4_2"
## [139] "amb4_2"   "shar4_2"  "attr2_2"  "sinc2_2"  "intel2_2" "fun2_2"
## [145] "amb2_2"   "shar2_2"  "attr3_2"  "sinc3_2"  "intel3_2" "fun3_2"
## [151] "amb3_2"   "attr5_2"  "sinc5_2"  "intel5_2" "fun5_2"   "amb5_2"
## [157] "you_call" "them_cal" "date_3"   "numdat_3" "num_in_3" "attr1_3"
## [163] "sinc1_3"  "intel1_3" "fun1_3"   "amb1_3"   "shar1_3"  "attr7_3"
## [169] "sinc7_3"  "intel7_3" "fun7_3"   "amb7_3"   "shar7_3"  "attr4_3"
## [175] "sinc4_3"  "intel4_3" "fun4_3"   "amb4_3"   "shar4_3"  "attr2_3"
## [181] "sinc2_3"  "intel2_3" "fun2_3"   "amb2_3"   "shar2_3"  "attr3_3"
## [187] "sinc3_3"  "intel3_3" "fun3_3"   "amb3_3"   "attr5_3"  "sinc5_3"
## [193] "intel5_3" "fun5_3"   "amb5_3"
```






```
##  [1] "iid"      "gender"   "age"      "race"     "age_o"    "race_o"
##  [7] "samerace" "attr"     "sinc"     "intel"    "fun"      "amb"
## [13] "shar"     "dec"
```

```
## # A tibble: 6 × 14
##     iid gender   age  race age_o race_o samerace  attr  sinc intel   fun   amb
##   <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1     1      0    21     4    27      2        0     6     9     7     7     6
## 2     1      0    21     4    22      2        0     7     8     7     8     5
## 3     1      0    21     4    22      4        1     5     8     9     8     5
## 4     1      0    21     4    23      2        0     7     6     8     7     6
## 5     1      0    21     4    24      3        0     5     6     7     7     6
## 6     1      0    21     4    25      2        0     4     9     7     4     6
## # ℹ 2 more variables: shar <dbl>, dec <dbl>
```



## EDA
![plot of chunk making a grpah for the distribution of race in the dataset](figures/eda/01_race_distribution.png)


```
## # A tibble: 6 × 2
##   race                                  number_of_people
##   <fct>                                            <int>
## 1 Black/African American                              26
## 2 European/Caucasian-American                        304
## 3 Latino/Hispanic American                            42
## 4 Asian/Pacific Islander/Asian-American              136
## 5 Other                                                0
## 6 <NA>                                                37
```


```
## [1] 545
```

![plot of chunk stacked bar chart of samerace vs dec](figures/eda/02_decisions_by_same_race.png)


![plot of chunk The Preference Matrix: race vs. race_o Match Rate](figures/eda/03_race_decision_heatmap.png)

![plot of chunk unnamed-chunk-4](figures/eda/04_attractiveness_boxplots.png)![plot of chunk unnamed-chunk-4](figures/eda/05_fun_boxplots.png)![plot of chunk unnamed-chunk-4](figures/eda/06_sincerity_boxplots.png)![plot of chunk unnamed-chunk-4](figures/eda/07_shared_interests_boxplots.png)![plot of chunk unnamed-chunk-4](figures/eda/08_ambition_boxplots.png)![plot of chunk unnamed-chunk-4](figures/eda/09_intelligence_boxplots.png)




```
##
##    0    1
## 3913 2967
```





```
##       Predicted
## Actual  No Yes
##    No  636 147
##    Yes 194 400
```

![plot of chunk unnamed-chunk-9](figures/logistic_regression/01_roc_curve.png)

![plot of chunk unnamed-chunk-10](figures/logistic_regression/02_precision_recall_curve.png)


|Metric            |  Value|
|:-----------------|------:|
|Accuracy          | 0.7524|
|Precision         | 0.7313|
|Recall            | 0.6734|
|F1 Score          | 0.7011|
|ROC-AUC           | 0.8183|
|PRC-AUC           | 0.7589|
|Average precision | 0.7593|

![plot of chunk unnamed-chunk-12](figures/logistic_regression/03_calibration_plot.png)


|   |Variable | Coefficient| Odds_Ratio|Direction          |
|:--|:--------|-----------:|----------:|:------------------|
|14 |attr     |      0.5488|     1.7311|Higher odds of Yes |
|2  |gender1  |      0.4284|     1.5348|Higher odds of Yes |
|19 |shar     |      0.2884|     1.3343|Higher odds of Yes |
|17 |fun      |      0.2732|     1.3142|Higher odds of Yes |
|13 |samerace |      0.1589|     1.1722|Higher odds of Yes |
|16 |intel    |      0.0641|     1.0662|Higher odds of Yes |
|6  |race4    |      0.0609|     1.0627|Higher odds of Yes |
|9  |race_o2  |      0.0105|     1.0105|Higher odds of Yes |
|3  |age      |     -0.0005|     0.9995|Lower odds of Yes  |
|8  |age_o    |     -0.0225|     0.9778|Lower odds of Yes  |
|11 |race_o4  |     -0.0325|     0.9680|Lower odds of Yes  |
|7  |race6    |     -0.0636|     0.9383|Lower odds of Yes  |
|12 |race_o6  |     -0.1224|     0.8848|Lower odds of Yes  |
|15 |sinc     |     -0.1294|     0.8786|Lower odds of Yes  |
|18 |amb      |     -0.1576|     0.8542|Lower odds of Yes  |
|10 |race_o3  |     -0.1987|     0.8198|Lower odds of Yes  |
|5  |race3    |     -0.3092|     0.7341|Lower odds of Yes  |
|4  |race2    |     -0.5407|     0.5823|Lower odds of Yes  |

![plot of chunk unnamed-chunk-14](figures/logistic_regression/04_coefficient_plot.png)







```
##
##   No  Yes
## 3945 2983
```




```
##       Predicted
## Actual  No Yes
##    No  603 186
##    Yes 195 402
```


```
##   probability_yes predicted_decision actual_decision
## 1       0.2720847                 No             Yes
## 2       0.6460285                Yes             Yes
## 3       0.1833393                 No              No
## 4       0.8311683                Yes              No
## 5       0.7696689                Yes              No
## 6       0.7860517                Yes              No
```


```
##   threshold  accuracy sensitivity_yes specificity_no balanced_accuracy
## 1       0.5 0.7251082       0.6733668      0.7642586         0.7188127
##     roc_auc   prc_auc average_precision
## 1 0.8017665 0.7197642         0.7210092
```



<div class="figure">
<img src="figures/neural_network/01_class_balance.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div><div class="figure">
<img src="figures/neural_network/02_confusion_matrix.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div><div class="figure">
<img src="figures/neural_network/03_roc_curve.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div><div class="figure">
<img src="figures/neural_network/04_precision_recall_curve.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div><div class="figure">
<img src="figures/neural_network/05_probability_distribution.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div><div class="figure">
<img src="figures/neural_network/06_calibration_plot.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div><div class="figure">
<img src="figures/neural_network/07_permutation_importance.png" alt="plot of chunk unnamed-chunk-23" width="2133" />
<p class="caption">plot of chunk unnamed-chunk-23</p>
</div>








```
## [1] 0.239
```

```
##       Predicted
## Actual   No  Yes
##    No  3160  753
##    Yes  890 2077
```

![plot of chunk unnamed-chunk-27](figures/random_forest/01_oob_error.png)

```
##   OOB
## 0.239
```

```
##       No  Yes class.error
## No  3160  753       0.192
## Yes  890 2077       0.300
```

```
##              No    Yes MeanDecreaseAccuracy MeanDecreaseGini
## gender   18.102  38.58                38.30             80.9
## age      17.976  29.33                32.68            368.3
## race     14.453  33.48                34.09            167.7
## age_o     0.657   5.68                 4.46            344.7
## race_o    4.725  12.22                12.08            170.7
## samerace  4.021   4.25                 5.90             55.6
## attr     79.559 143.90               153.42            675.3
## sinc     11.493  33.16                33.73            243.7
## intel    10.411  23.31                26.86            215.7
## fun      52.657  43.92                76.85            378.2
## amb      13.891  16.09                22.59            235.6
## shar     49.124  69.71                90.55            391.7
```

![plot of chunk unnamed-chunk-27](figures/random_forest/02_variable_importance.png)



![plot of chunk unnamed-chunk-29](figures/random_forest/03_roc_curve.png)

```
## [1] 0.842
```

![plot of chunk unnamed-chunk-30](figures/random_forest/04_precision_recall_curve.png)

```
## [1] 0.794
```

![plot of chunk unnamed-chunk-31](figures/random_forest/05_calibration_plot.png)

```
## [1] 0.161
```

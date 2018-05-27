# Predict the average recipe rating on BBC Good Food- To improve quality of BBC Good Food recipes
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/cover.JPG)

- ## Executive Summary
The primary stakeholder is BBC Good Food which is a recipe website related to BBC.   The problem is that it is not the most popular website since it does not appear on the first page when user searching in Google website by keyword as “recipe website”.  Hence, the business goal of this project is to improve the quality of recipes on the website. By doing so, we aim to attract more people to visit the website and the analytic goal of the project is to predict the average rating value of new recipe before publishing.

The data were crawling by ourselves from the BBC Good Food website. The total numbers of data were about 8,400 records. After we had collected the data, we decided to handle the missing values by replacing them with the average value of each column. We also binned those predictors with too many categories, such as country and serving, into few categories. Besides, we derived a “total time” variable by plusing prepare time and cook time together. After the data were prepared, we processed some visualization to help us know the data better.

We picked four tools as the follows: prediction tree, KNN, multiple linear regression and Principal Component Regression to help us analyze. By comparing all the results, we chose multiple linear regression as our model which results were less error. Most importantly, we could get a specific result to show the client how the rating value does improve.

We suggest BBC Good Food that they could increase prepare time, cooking time of the dish, writing more article related to Side Dish and Starter, considering carefully when writing recipes about dinner or afternoon tea since it tends to get low rating value. We assume that readers might prefer something new and creative and choosing the dish level that is neither too hard nor too easy.

## 1. Problem Definition
- ### Business goal
Our main stakeholder is BBC Good Food, which is a recipe website related to BBC. Unfortunately, it is not the most popular recipe website. Our goal is to improve the quality of recipes on BBC Good Food website.  We would like to make the website more attractive and to be well-known by word of mouth.

- ### Analytics goal
Our analytics goal is to predict the average rating value of each new recipe, supervised, predictive and forward-looking method and the outcome will be numerical. If the predicted rating value is close to the actual rating, we would consider it as success prediction. However, we still need some domain knowledge to define closeness. 

## 2. Data Preparation
We used software “python” to crawl data from a recipe website, BBC Good Food. Additionally, we used software “R” to clean the data and converted to csv in order to run our models. Besides, all variables we collected were as Table below.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/table1.jpg)
From cleaning processes (see Appendix A), we have 8,408 records, each record stands for a recipe, and there are 42 predictors (including all dummy variables we used) in the end (see Table below).
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/table2.jpg)

## 3. Data Exploration 
- ### Average rating value distribution
We used histogram to see the distribution of rating number, we found out most of the values were distributed around 3~5 points. There were also couples of number at 0 point which need to be noticed. The rating value 0 may be caused by two following reasons: no one rates the recipe and the recipe is just posted on the website lately. Thus, we decided to keep the recipes which were post at least 1 month on the website.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/B.1.jpg)

- ### Total Using time (Cook time +Prepare time) vs. AVG Rating value
In general, we would consider long cooking time as low rating value. After we plot the time versus rating value, graph we found that when the time got certain long enough, the value tend to be high.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/B.2.jpg)

- ### Ingredient vs. Average Rating Value
We found that when the ingredient is fewer than 3.75, the rating value is centralized around 3 to 5 points. Comparing to the number larger than 3.75, people tend to give high rating value that needs few ingredients to cook.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/B.3.jpg)


## 4. Data Mining Solution 
### Method 1.Regression Trees
We tried running our data with prediction tree method to create model and we found that the most eight significant predictors were as follows: `kcalories`, `category_drink`, `category_condim`, `protein`, `cook time`, `fibre`, `sugar` and `saturates`. In addition, the performance was showing as Table below and also, the full tree was showing as below.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/table3.jpg)


### Method 2.KNN
We also tried KNN method and imported all the variables to run the model, which was good at predicting continuous numerical output, and the performance was showing in the Table below. However, in this case, we would not prefer KNN method, because it was a black box and could not provide variable selection to reduce dimensions. Also, it was not well of explaining data, and we were not able to give recommendation to our client.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/table4.jpg)

### Method 3.Multiple Linear Regression
At the beginning, we imported all variables and selected "stepwise" variable selection to see what kind of predictors combination performed well. 

![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/C.1.jpg)

We choose subset#14, which CP value was mostly close to coefficient, to running the regression model again, and the performance is showing in Table below. Finally, we got our best model in regression:
Y=0.00289*Saturates+0.02035*Salt+0.00086*Total_time+(0.10653)*Dinner+0.12083*Side_dish+(0.0977)*Afternoon_tea+(0.08404)*Supper+0.40145*Starter+0.06988*America+(0.05537)*Asia+0.03465*Europe+0.0933*Level_Moderately easy
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/table5.jpg)

### Method 4.Principal Component Regression (PCR)
We constructed regression models using 2 principal components we chose by screeplot below as independent variables, trying to get less error. Additionally, in order to run this model, we installed a package “pls” in R ([link to R code](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/code/Principal%20Component%20Regression.r)). Finally, we got SSE = 5720.424, RMS Error=1.51, and Aver. Error=0.0314.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/C.2.jpg)

## 5. Model Evaluation
- ### Compare Four Methods
Speaking of comparing the error, the number of data is important. Here we had the same number of data and set the same seed when running all the methods. We compared these results in Table below, we found that regression all got the smallest numbers among these errors item. Thus, we chose regression to be our final model. 
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/table6.jpg)

- ### Residual Evaluation 
According to 3 histograms of different residuals below. All are central with 0 but it shows that it has no big improvement after we adjusted the model by comparing first figure and third figure. Therefore, we still choose the original regression model as our final model.
#### 1. Original model
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/D.1.jpg)
#### 2. Adjusted-log Y model 
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/D.2.jpg)
#### 3. Adjusted- log Y model but transformed to original scale
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/D.3.jpg)


## 6. Conclusion 
- ### Advantages
BBC Good food is able to acknowledge the average rating of recipe that they will easily get before publishing. They could make adjustments to improve the quality and increasing rating. According to p-value and coefficient sign of each predictor in regression model from Table below, we could present 4 recommendations to BBC Good Food, how to adjust article to get high rating as follows: 1) increasing prepare time, cooking time of the dish; 2) writing more article related to Side Dish and Starter; 3) considering carefully when you are writing recipes about dinner or afternoon tea since it tends to get low rating value. We assume that readers might prefer something new and creative; 4) choosing the dish level that is neither too hard nor too easy.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Supervised%20Learning/figures/D.4.jpg)

- ### Limitation
Since BBC Good food is a recipe website from England, most recipes in our dataset are European cuisine (around 70 percent), and our model was built based on this dataset. As a result, our model is likely to work well only with European recipes. Moreover, scale of rating value was quite small, from 0 to 5, errors of prediction might not be reflected what it is in reality.   
- ### Operational Recommendations
From data exploration process, we found there were different units of measures in serving predictor such as people, gram or milliliter. Thus, user should be aware of this issue before running model and manually bin it into proper range. Besides, we could not judge the error by the number, since our scales are too small (from 0 to 5). We may need some domain knowledge to help us. To know how to define the benchmark, which would be valuable for our client. Besides, for other data mining projects regarding article data in the future, we would suggest them to know their data by playing and exploring them.



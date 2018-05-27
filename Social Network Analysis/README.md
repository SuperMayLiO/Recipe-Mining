# Knowledge Discovery of Cuisine between Europe Regions Using Network Analysis

## 1. Introduction
Food can be a large part of human’s lives. According to Choi (2014), what you want to cook and eat is an accumulation, a function of your experiences — the people you’ve dated, what you’ve learned, where you’ve gone. Therefore, this experiment is conducted to focus on Europe, trying to see whether there’re some common features between four regions’ cuisine.

Teng, Lin, and Adamic (2012) used the complement network to capture which ingredients tend to co-occur frequently, based on pointwise mutual information (PMI) defined on pairs of ingredients. Ahn, Ahnert, Bagrow, and Barabasi (2011) introduced a flavor network that captured the flavor compounds shared by ingredients. Kular, Menezes, and Ribeiro (2011) performed community analysis and correlate that with the ground truth available for each recipe (region or country of origin) to delve into different cultures. From above, we can see that these experiments show different ways to define networks. By extending more on their limitation, the goal is to build the network considering quantities (using small sample to try), to dig more in food between different countries!

This experiment depends on about 9,000 recipes from website, BBC Good Food, which is a website made by BBC Worldwide, being a commercial company owned by BBC, this experiment is conducted to use nodes to represent recipes or ingredients, and edge is the relationship between these two recipes or ingredients. Moreover, with regard to McGee (1984), hoping to utilize this book not only augments domain knowledge about cuisine history, but also research more on some kind of significant incidents between cultures or countries, after finding core ingredient; therefore, people can realize more about Europe cuisine between cultures, according to ingredient network in this experiment which gives people pictures about cuisine !

## 2. Methodology
- ### Data Preprocessing
- #### Parsing Ingredient Mapping table
We can’t find a meticulous ingredient list that fit all the ingredient in our dataset, so we need to construct it by ourselves. First of all, for distinguishing ingredients, we use NLP(Natural Language Processing), a method that can classify parts in a sentence, on both ingredients and cooking method, then intersect the result “NN” , which means Noun, appearing most times. On the other words, we don’t want to lost compound Noun. 

The reason why we use both ingredients and cooking method is that some redundant Noun would be in ingredients but not in cooking method. Take “150ml pot soured cream” for example. We only want to extract “soured cream”, but if we only use the ingredient as NLP input, “pot” is also distinguish to Noun. However, most of the recipe would not emphasize the word “pot” again in cooking method. Giving more example, “extra-virgin olive oil” would become “olive oil” and “vegetarian parmesan-style cheese” would become “cheese” On the other hand, this also can make sure all the ingredient are used when implement cooking method.

After extracting all possible ingredients, we pick the ingredients manually to improve the quality of our ingredient list and do the following cleaning criterion :
> ##### (1) For plural Noun, there is a package called NTLK in python can deal with it. However, considering we need extremely high qualities of ingredient to build the network, we handle this problem by our knowledge.
> ##### (2) For specified ingredients, we convert them to more general ones (e.g. for ingredient, sugar, data shows that there are 8 types: golden caster sugar, demerara/raw sugar, dark brown soft sugar, light brown soft sugar, light and dark muscovado sugar, granulated sugar, caster sugar and icing sugar, so we refer to the ingredient list whichKNOWLEDGE DISCOVERY OF CUISINE USING NETWORK ANALYSIS 8 website provides to divide into only two types of sugar: brown sugars and white sugars.)
> ##### (3) For ingredient in brand names, we convert them to the category (e.g. converting Cointreau to fruit wine)
> ##### (4) For extract (e.g. almond extract), we will use original ingredients to stand for them (e.g. almond).
> ##### (5) For mixtures (e.g. 650g mixed fruits, such as strawberries, pineapple chunks, grapes, mango chunks, melons chunks), they will be considered as only one kind of ingredient (e.g. mixed fruits).
> ##### (6) For decoration which can’t be eaten, we delete directly (e.g. ribbon).
> ##### (7) If an ingredient appear more than once in a recipe, we use total weight.

- #### Idetifying quantifiers
To quantify ingredients, we use regular expression 

```cmd
[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)* | [0-9]*½ *( *handful)+ | [0-9]*½ *( *bunch)+ | [0-9]*½ *( *little)+ | [0-9]*½ *( *pack)+ | [0-9]*½ +[a-z]*( +tsp)*( +tbsp)* | [0-9]+[a-z]*( +tsp)*( +tbsp)*
```
to extract special symbols : “x” appearing alone meaning multiply(e.g. 2 x 7g sachets easy-bake dried yeast), “½” meaning 0.5(e.g. ½ tsp ground cinnamon), etc. and general patterns : the first pattern with digits, a space and the following alphabets (i.e. hoping to extract g, ml, kg, tbsp, tsp, etc.) and some common quantifiers with whether digit appearing (e.g. handful, little, pack, bunch, etc.) For example, we want to extract “2 tsp” from “2 tsp paprika” or “handful” from “handful of parsley leaves, roughly chopped”, etc.

- #### Quantifying Ingredients and Classifying “many” or “few” Ingredients
For those quantifiers hard to measure (e.g. handful, pack, etc.) and without units, although we can just assign handful to “few” because the recipe writer may not care the quantities, to satisfy our need later when building network, considering the serving are different among recipes, a “pack” can’t assign to “many” directly, so we give them a subjective quantities in order to standardize.  We will divide all measurements into two parts: “many” and “few” by whether the weight of an ingredient is bigger than the ingredient mean weight in a particular recipe to handle this problem easily. Table below shows the procedure and result. 

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/table1.png "Data Processing Procedure and Measurement")

To sum up, we scrap the data from website, BBC Good Food.com, obtaining a really “dirty” dataset. With series of manually data processing, we finally acquire a dataset, whose rows are ingredients (total ingredients =236), columns are recipe (total recipes =200), and the values inside are all “many” or “few”, which can fit the requirement to construct the following network.

- ### Networks Structure
With the ingredient-by-recipe matrix, we can typically construct three kinds of network － an ingredient-by-recipe two-mode network , a recipe-by-recipe co-ingredient one-mode network , and an ingredient-by-ingredient co-recipe one-mode network.

- ##### Ingredient-By-Recipe Two-Mode Network
Rows are ingredients and columns are recipes, and the digits in the matrix should be 0 (meaning an ingredient is not used in a recipe), 1 (meaning an ingredient is used as a minor ingredient in a recipe), and 2(meaning an ingredient is used as a main ingredient in a recipe (e.g. from col.2 and 3 of Table below, brown sugar is a minor ingredient in recipe, orange & ginger stained glass biscuits; however, it’s a main ingredient in recipe, Black Forest gateau).

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/table2.png "Ingredient-by-recipe matrix (Patial)")

- ##### Recipe-By-Recipe Co-Ingredient One-Mode Network 
Both rows and columns are recipes. Because there is no direction in this network, Table below is a symmetric matrix. The value in the matrix is the number of ingredient shared by the recipe in row and the recipe in column (e.g. Pork schnitzel share 2 ingredientsKNOWLEDGE DISCOVERY OF CUISINE USING NETWORK ANALYSIS 13 with Black Forest gâteau), and the value of diagonal is the number of ingredients used in the recipe (e.g. Black Forest gateau use 13 ingredients). In this paper, we only use this dataset to detect an overall pattern in categories (dessert, dishes, meals, salads, and soups) and regions (Western Europe, Central Europe, Northern European, and Southern European.)

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/table3.png "Recipe-By-Recipe Matrix (Partial)")

- ##### Ingredient-By-Ingredient Co-Recipe One-Mode Network 
In Table below, both rows and columns are ingredients. With the direction, the  atrix may not be symmetric. The value in the matrix means the times of the following situation happen: the row ingredient is minor (few) and the column ingredient is main (many).

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/table5.png "Ingredient-By-Ingredient Matrix with Direction (partial)")

- ### Building Networks
Not like recipe-by-recipe network, for ingredient-by-ingredient matrix with direction, we are going to calculate two kinds of centrality indicator to know the relationship between ingredients better:
> ##### (1) PageRank. This algorithm is original used to evaluate the importance of website. If a website is cited (the website’s URL is posted on other’s website) more and more times, the website would become more and more popular. In other words, if a person random enter a website, then for the result of next step, the person have more probability to visit the most cited website. The same concept can be move to network analysis. That is, randomly select a node in the network to be a minor ingredient, which node would be more possible to be the main ingredient if the node keep finding the most possible main ingredient each step. link to the higher centrality nodes but less possible to link to the lower centrality nodes. In a word, the nodes with higher centrality would have smaller distance to all the other nodes because the most possible have linkage between two nodes is equivalent to (distance means the shortest path from a node to another).

> ##### (2) In-degree Centrality. It is the number of a node being pointed by other nodes. In ingredient-by-ingredient network with direction, higher in-degree means that an ingredient is a main ingredient in the network (e.g. the maximum in-degree is tomatoes with 216 edges link to it).

> ##### (3) Out-degree Centrality. Contrary to in-degree, out-degree centrality is the number of a node point out . In ingredient-by-ingredient network with direction, higher in-degree means that an ingredient can be a collation to lots of ingredients. That is, it could be a minor ingredient in the network (e.g. the maximum out-degree is olive oil with 142
edges point out from it).


## 3. Results
We filter 200 recipe to visualize the result

- ### Recipe-By-Recipe Co-Ingredient One-Mode Network

- ### Ingredient-By-Ingredient Co-Recipe One-Mode Network

- ### Ingredient-By-Recipe Two-Mode Network


## 4. Discussion


## 5. References
### Ahn, Y., Ahnert, S., Bagrow, J., & Barabasi, A. (2011). Flavor network and the principles of food pairing. SCIENTIFIC REPORTS, 1-7, doi:10.1038/srep00196
### Choi, A. S., (2014, December 18). What Americans can learn from other food cultures. IDEAS.TED.COM. Retrieved from http://ideas.ted.com/what-americans-can-learn-from-other-food-cultures/
### Kular, D. K., Menezes, R. & Ribeiro, E. (2011).Using network analysis to understand the relation between cuisine and culture. Proc. 2011 IEEE 1st Int. Netw. Sci. Work.
### McGee, H. (1984). On food and cooking—the science and lore of the kitchen. New York, NY: MacMillan.
### Teng, C.-Y., Lin, Y.-R., & Adamic, L. A. (2012). Recipe recommendation using ingredient networks, Proc. 3rd Annual ACM Web Science Conference, 298–307.







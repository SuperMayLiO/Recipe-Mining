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

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/table4.png "Ingredient-By-Ingredient Matrix with Direction (partial)")

- ### Building Networks
Not like recipe-by-recipe network, for ingredient-by-ingredient matrix with direction, we are going to calculate two kinds of centrality indicator to know the relationship between ingredients better:

> ##### (1) PageRank. This algorithm is original used to evaluate the importance of website. If a website is cited (the website’s URL is posted on other’s website) more and more times, the website would become more and more popular. In other words, if a person random enter a website, then for the result of next step, the person have more probability to visit the most cited website. The same concept can be move to network analysis. That is, randomly select a node in the network to be a minor ingredient, which node would be more possible to be the main ingredient if the node keep finding the most possible main ingredient each step. link to the higher centrality nodes but less possible to link to the lower centrality nodes. In a word, the nodes with higher centrality would have smaller distance to all the other nodes because the most possible have linkage between two nodes is equivalent to (distance means the shortest path from a node to another).
> ##### (2) In-degree Centrality. It is the number of a node being pointed by other nodes. In ingredient-by-ingredient network with direction, higher in-degree means that an ingredient is a main ingredient in the network (e.g. the maximum in-degree is tomatoes with 216 edges link to it).
> ##### (3) Out-degree Centrality. Contrary to in-degree, out-degree centrality is the number of a node point out . In ingredient-by-ingredient network with direction, higher in-degree means that an ingredient can be a collation to lots of ingredients. That is, it could be a minor ingredient in the network (e.g. the maximum out-degree is olive oil with 142
edges point out from it).


## 3. Results
We filter 200 recipe to visualize the result from four Europe regions(Western Europe, Northern Europe, Central Europe, and Southern Europe. Eastern Europe do not have enough samples.)

- ### Recipe-By-Recipe Co-Ingredient One-Mode Network
For nodes, each node represents a recipe. For edges, or the relationship that two recipes share at least one ingredient (i.e. common ingredient). 

#### Recipe-By-Recipe Network (area)
In Figure below, there are a few patterns that nodes in light blue gather together on the top right side. Besides, half of green nodes on the bottom left side, and for other two color of nodes, they distribute evenly in this network.

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure2.png "Recipe Network (yellow =Western Europe, green=Central Europe, blue = Northern European, light blue = Southern European.)")

#### Recipe-By-Recipe Network (category)
Moreover, we divide recipes into five categories, then use the same as previous network, but only change the color to represent different courses, the main difference between dish and meal is that whether the course can be eaten without other food in a meal (e.g. “So-simple spaghetti Bolognese” is a meal and “Creamy cucumber with gravadlax” is a dish) . In Figure below, all recipes are to construct a recipe network and there are some clear patterns that same category of recipes may share more ingredient. For example, most of the desserts gather together on the bottom left, soups are in the center of the network, and salads are in the right of the network. However, the meals and dishes are hardly to distinguish, because they almost share the same ingredients when we cook both kinds of cuisine. Something interesting we find here is that there are few courses from Southern Europe are desserts (compare with Recipe Network with region).

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure3.png "Recipe Network (yellow =Western Europe, green=Central Europe, blue = Northern European, light blue = Southern European.)")

To explore relationship between recipes, we retain the edges whose nodes have at least more than a threshold. In Figure below, we delete repeated recipe (i.e. 23 of 200 recipes) and edges which less than a threshold of sharing ingredients, then build 6 network whose nodes share at least 3 to 8 ingredients from top left to bottom right. Here is another exciting pattern that desserts share most of their ingredients with the increasing of minimum links, so in the last picture, only shows the desserts share at least 8 ingredients

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure4.png "Recipe Network (yellow =Western Europe, green=Central Europe, blue = Northern European, light blue = Southern European.))")


- ### Ingredient-By-Ingredient Co-Recipe One-Mode Network
Nodes are ingredient; they are linked because they are used in the same recipe and the direct is from minor ingredient point to main ingredient, meaning that the minor ingredient plays a second role in the recipe, so the usage of minor ingredient is to serve with a plus effect to main ingredient. We use ingredient-by-ingredient network with direction to calculate the previously proposed indicators.


In Figures below, vertex color means the purity of a node to be main ingredient or minor ingredient. In other words, the nodes in pink are main ingredients and nodes in red are minor ingredients. The vertex size means the times of an ingredient is used. On the other hand, in edges, the edge color in black means that among all used recipe, the two
ingredients almost play the same rule－ one is main ingredient and the other is minor ingredient. The edge size means the times of two ingredient co-occur in recipes. Figures below are Ingredient Network with Degree of node more than 10 and 15. We can find that chicken, pork, beef, mushrooms, tomatoes, and potatoes are in color pink, so they are always main ingredients in recipe. On the other side, baking powder, fruit vinegar, nutmeg, olive oil, and lemon are always minor ingredient

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure5.png "Ingredient Network with Degree of node more than 10")

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure6.png "Ingredient Network with Degree of node more than 15")

- ### Ingredient-By-Recipe Two-Mode Network
The nodes can be both recipe and ingredient, and the edges mean that one ingredient is used in a certain recipe. Therefore, there won’t be any edge among nodes of ingredients and among nodes of recipes; there will only be between a node of ingredient and a node of recipe. 

#### Ingredient-By-Recipe Network (area)
We compute the in-degree and out-degree separately in four area. That is, we distinguish the 50 recipe from every area, and convert each area to an ingredient-by-ingredient matrix. Next, we pick up the top 5 in-degree and out-degree ingredients to build main ingredient network and minor ingredient network. In Figure below, in main ingredient network (top 5 in-degree ingredients in each area), we surprisingly found that Southern Europe hardly share main ingredients with other area. 

By Recipe-By-Recipe Network, there are a little dessert in Southern Europe, which cause the main ingredients are quite different from other areas. Moreover, if an ingredient link to two areas, these two areas have a relationship that use the same ingredient. We also found that Northern Europe share 4 of the top 5 ingredient to Central Europe. Besides, eggs act as main ingredients in 4 regions, but when they are used in Southern Europe, they are more likely to be made Omelet or Scrambled eggs. However, when eggs are used as main ingredient in Western Europe and Central Europe, they are probably used the eggs white to make cakes. Furthermore, we can find that most of the top 5 main ingredient in Western, Northern, and Central Europe are lots of ingredients to make dessert

In Common Ingredient-By-Recipe Network (area) below, we used PageRank as centrality to build a common ingrdients network. Garlic, milk, potatoes, and eggs are shared, which means these ingredients are most likely to reach others. In other words, they could be compared to many ingredients than others. Therefore, these ingredients are necessary when making European cuisine.

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure7.png "Ingredient-By-Recipe Network (area)")

#### Ingredient-By-Recipe Network (category)

In Main Ingredient-By-Recipe Network (area), we found that the milk and eggs which used most in almost four area. Here, in Main Ingredient-By-Recipe Network (category), we furthermore find that these two ingredients are only use when making dessert and soup. Moreover, tomatoes and garlic are shared by meal, salad and dish but only used in Southern Europe. This also because that there are few dessert in Southern Europe, the weight are enhance in main courses. In Minor Ingredient-By-Recipe Network (category), we found that butter could be used to make meal and not in salad. Olive oil would not be used to make dessert. Onions are only used to make meal, soup, and dish. In Common Ingredient-By-Recipe Network (category), the pattern looks like Main Ingredient-By-Recipe Network (category), because the main ingredient are more common than minor ingredients. Therefore, main ingredients could have a greater impact on centrality.

![alt text](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Social%20Network%20Analysis/figures/figure8.png "Ingredient-By-Recipe Network (category)")

## 4. Discussion
We scrap data from BBC Good Food website, after a long procedure of analysis, finding that Southern Europe may be in a different food culture with other regions (Western, Northern, and Central Europe). In main ingredients, there are less ingredient shared by regions, except eggs and milk. That is quite trivial that European loves to eat diary no matter
in desserts or dishes. On the other hand, olive oil, butter, and onions are more likely to serve as minor ingredients. However, butter do not serve as minor ingredient in Southern Europe because butter are used to make dessert and there are few dessert in Southern Europe. Nevertheless, there are some limitations in this paper. First, we can’t use a perfect way to clean the ingredient quantifier, and a fair ways to give ingredient weight so we can apply this work to a bigger scale of research. Secondly, the data are scrapped from website, even ifKNOWLEDGE DISCOVERY OF CUISINE USING NETWORK ANALYSIS 27 the website is convincing for European recipe, there are still some repeated recipe among different regions. Therefore, we should do more research to find mainstream recipes among countries. Last but not least, even though we give the fair metric, the ways people choosing ingredients are affected not only by weight but also by flavor, texture, price, agriculture etc. This would become a great work if we consider all these variables, therefore, we expect that
we can deal with these step by step in the future!

## 5. References
Ahn, Y., Ahnert, S., Bagrow, J., & Barabasi, A. (2011). Flavor network and the principles of food pairing. SCIENTIFIC REPORTS, 1-7, doi:10.1038/srep00196

Choi, A. S., (2014, December 18). What Americans can learn from other food cultures. IDEAS.TED.COM. Retrieved from http://ideas.ted.com/what-americans-can-learn-from-other-food-cultures/

Kular, D. K., Menezes, R. & Ribeiro, E. (2011).Using network analysis to understand the relation between cuisine and culture. Proc. 2011 IEEE 1st Int. Netw. Sci. Work.

McGee, H. (1984). On food and cooking—the science and lore of the kitchen. New York, NY: MacMillan.

Teng, C.-Y., Lin, Y.-R., & Adamic, L. A. (2012). Recipe recommendation using ingredient networks, Proc. 3rd Annual ACM Web Science Conference, 298–307.







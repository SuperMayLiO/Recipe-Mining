# Knowledge Discovery of Online Recipe Reviews Using Text Mining
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/cover.jpeg)

## Abstract
The goal is to discover and explore Europe recipe experience world. Therefore, this experiment is conducted to utilize critical incidence and K-means clustering analysis to create ontology. Firstly, collect recipe samples from four European regions to build the clusters of positive and negative recipe experience; however, there’s no special pattern in clusters for creating ontology. Secondly, build clusters of positive and negative recipe experience for Europe recipes; however, there’s just a little pattern for creating ontology. Finally, partitioning same samples into two categories, i.e. “Dish” and “Others” (dessert & salad & soup) of Europe recipes, and building 4 clusters of both positive and negative recipe experience and finding ideas to create ontology.

*Keywords: text mining, online recipe, critical incidence, ontology, clustering



## 1. Introduction
The Internet has gradually affected people’s lives, people would like to share their experience on the web, including recipe experience. The website, BBC Good Food was founded in 2001, which was made by BBC Worldwide and was a commercial company owned by BBC, provides with about 9000 recipes of their magazine on this website. Moreover, establishing a platform for online reviewers who followed this recipe before to share their experience and modification for each recipe! 

With regard to Rese, Schreiber, and Baier (2014) mentioned a technique, text mining which was applied to this experiment to identify important adjective pairs out of the online reviews of IKEA's mobile catalogue app, which gave a more realistic picture of the difficulties and problems than traditional approaches, e.g. using questionnaires, to measure technology acceptance. Additionally, result shows that it not only contributes valuable ideas for technical improvements to the mobile IKEA catalogue app, but can be replaced by the analysis of online reviews with comparison survey. Therefore, applying this research to my further studies to find out whether important incidents/words exists in recipe can be more possible to be executed. In other words, in this experiment, is to discover the critical incidents in online reviews from website, BBC Good Food.

From Trappey, Wu, and Liu (2012), further experiment is conducted to apply their Kaohsiung MRT ontology to accomplish further research by making cooking experience ontology from online reviews of BBC Good Food depending on various recipes. Lee, and Hu (2004) showed a similar way to understand critical incidents, appearing in hotel customers from website, e-Complaints. Furthermore, this experiment is conducted to group customers’ descriptive comments about hotel service, called cluster analysis–examining keyword association by grouping identified important keywords based on Ward’s clustering method. This further research can be conducted by applying with another hierarchical method, but changing to use another algorithm, called K-means, which is also for clustering but it’s nonhierarchical clustering, to discover whether there’re critical incidents in online recipe reviews, and being clustered by some association. With regard to the idea of Teng, Lin, and Adamic (2012), the experiment was conducted to use the comments from a recipe website, Joy of Cooking, to modify the recipes, which is similar to further research with similar way, called text mining, and to find out critical incidents in recipes’ reviews; however, further research is conducted to adjust previous idea to focus on only one country, United Kingdom, data collected from website, BBC Good Food. On one hand, utilizing online reviews below each recipe, which were posted by almost U.K. people who followed this recipe before; therefore, we can try to find out how to adjust recipes from BBC Good Food in order to realize U.K. customers’ taste before bringing out new dishes, which can prevent new dishes from failure. In other words, adjusting recipes helps lead dishes to success. Besides, focusing on what people like and strengthen their satisfaction, which also can be a great thing! On the other hand, with regard to Ahn, Ahnert, Bagrow, and Barabasi (2011), this experiment was conducted to use two American repositories and avoid a distinctly Western interpretation of the world’s cuisine, also used a Korean repository at the same time. Besides, the results showed that the correlation between different datasets (recipes of different repositories), representing two distinct perspectives on food. From this, this experiment can be conducted to focus on recipes, which demonstrate U.K. tastes and recipe experience with U.K. style because all recipes collected from an English website, BBC Good Food.

About recipe modification, transforming the core idea from Teng, Lin, and Adamic (2012), and all techniques mentioned previously, the goal for this experiment is conducted to separate two parts by analyzing negative recipe experience and positive recipe experience depending on reviewers’ ranking for recipes to dig more in U.K. people’s taste on recipes!

## 2. Methodology
We try to use critical incident analysis to discover what BBC Good Food users experience when they followed these recipes previously, which is similar to Yan, and Zhang (2006), trying to apply this technique to build customer complaint ontology; therefore, this experiment is to focus on Europe recipes, building U.K. people’s recipe experience ontology. Furthermore, we use K-means clustering analysis with the key phrase dimensions (Trappey, Wu, and Liu, 2012) and discovering knowledge about what U.K. people experience in European recipes and how they feel about European cuisine!

- ### Data preprocessing
This experiment is conducted to collect and clean about 9000 recipes from website, BBC Good Food, through two software, Python and R; however, we only use 8331 recipes, which contain four European regions: Western Europe with 6499 recipes, Northern Europe with 130 recipes, Central Europe with 65 recipes, and Southern Europe with 1637 recipes because data resources from website, BBC Good Food.com, provided with less Eastern Europe recipes. Therefore, we only focus on four European regions. Moreover, randomly sampling 50 recipes from each region to prevent the problem that Northern Europe and Central Europe have few recipes. In sum, this experiment is conducted to use 200 samples from 8331 recipes to find out some interesting things in European cuisine world ([link to R code](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/code/1.Prepare%20data)). 

To build two kinds of attitude ontology, the first step in processing the recipes is defining positive part and negative part from comments of each European region recipes. We remove intermediate attitude, or the star ranking of reviewers were 2.5 stars (from decimal viewpoint), and 3 stars (from integer viewpoint) depending on total ranking, 5 stars. On one hand, regarding what’s greater than 3 stars as positive attitude for four European regions. On the other hand, regarding what’s less than 2.5 stars as negative attitude for four European regions. Besides, we put dialogues together if there’re the same reviewers for two attitudes!
The next step in processing the recipes is to remove something meaningless, such as notation (e.g. -/), stop word, i.e. is a commonly used word (e.g. of, for, a, the), numbers, and space. Besides, also transform all words to small letter to distinguish repeated words.

- ### Critical Incident Analysis
Critical incident technique consists of a set of procedures for collecting direct observations of human behavior to facilitate their potential usefulness in solving practical problems (Flanagan, 1954). Besides, it can be used to construct an open-ended website users’ comments to analyze from the positive and negative viewpoints of users describing their cooking experiences, as the similar application from Trappey, Wu, and Liu (2012), who use open-ended customer questionnaire to collect the positive and negative text dialogues of passengers describing their transportation experiences. In this research, we will collect people’s comments on website, BBC Good Food, to know users’ detailed experience using their own words and explanations. The table shows how many positive and negative dialogues for four regions (Table.1). 
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/table1.JPG)

- ### Text Mining Analysis
In order to extract the keywords from recipe reviews, this experiment is conducted to count the weights of words by following way ([link to R code](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/code/2.Text%20Mining)). Utilizing the method proposed by Salton and Buckley (1988), we can calculate Term Frequency (TF) minus Inverse Document Frequency (IDF). TF is measuring number of times a word appears in a recipe review, and IDF is measuring number of times the word appears in all reviews, which are either positive dialogues or negative dialogues from four European regions mentioned before. This method was combined the idea of TF, proposed by Luhn (1957), with the idea of IDF, proposed by Jones, K. S. (1972). However, in order to solve the problem that the length of dialogue (i.e. recipe comments) will affect the weight of words, then use the method, Normalized Term Frequency (NTF) minus Inverse Document Frequency (IDF), proposed by Sedding, and Kazakov (2004). Therefore, in this experiment, we calculate NTF minus IDF to give appropriate weights of words, choosing top 50 words from top 100 words, using domain knowledge to pick vital or meaningful words manually.

- #### K-means clustering analysis. 
Additionally, according to top 50 keywords selected, we then use K-means clustering analysis with the keyword dimensions (Trappey, Wu, &Liu, 2012). In other words, we desire to discover some patterns to help us build U.K. people’s recipe experience ontology. However, when utilizing K-means clustering, creating clusters to see whether there’re different patterns for positive and negative dialogues in four regions, the results show no special patterns to explain in each cluster (Figure.1~Figure.8). Moreover, because sample sizes for negative dialogues are too small in four European regions (Table.1), this experiment shows that there’re only ten keywords extracted from negative dialogues in four regions. Besides, we think that if people do not like the recipes, they won’t go back to comment on recipes they followed before. Therefore, we try to combine 200 samples of four European regions to see positive and negative recipe experience in Europe, finding keywords for recipe experience clustering! Besides, the number of positive dialogue is 1065, negative dialogue is 104 (see the dataset in appendix A). 

- #### Recipe experience ontology. The final step here is to use clusters created previously to give an idea for creating positive and negative Europe recipe experience ontology for U.K. people (e.g. Trappey, Wu, & Liu ,2012; Yan, & Zhang ,2006).
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure1.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure2.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure3.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure4.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure5.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure6.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure7.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure8.JPG)

## 3. Results
A total of 4 clusters were derived from both good and bad experiences for 200 samples of Europe recipes (actual comments for 200 samples of Europe recipes are in Appendix A). Figure 9 depicts the good experiences. However, we can only find special patterns in forth cluster. The forth cluster relates to the topic about breakfast, and shows something that people love in breakfast; in other words, dried fruit and nut topping on yoghurt, and syrup spreading across granola, which depicting a wonderful morning (R codes are in Appendix C and Appendix D) !
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure9.JPG)

Figure 10 depicts the bad experiences. However, we cannot find any special pattern in these four clusters, which means we have to change to another way, exploring more recipe experiences from reviewers!
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure10.JPG)

As a result, we keep trying to explore positive and negative comments between dish and others (dessert& salad& soup), i.e. building positive and negative recipe experience ontology for two partitions (dish and others; see Table.2), finding keywords for building clusters, creating recipe experience ontology, depending on this partition of dish and others (actual comments for 200 samples of “Dish” and “Others” recipes are in Appendix B)!
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/table2.JPG)

We derived 4 clusters for positive comments of “Dish” (Figure 11 & Figure 12). Figure 11 depicts the good experiences. Furthermore, the first and forth cluster depicts about tasty or fresh main dish and flavor, which gives us an idea to come up with a reason for reviewers’ satisfaction. Besides, we can also find the topic about health (or low fat) in the second cluster, and crème fraiche is mentioned in positive dialogues so many times to substitiute for sour cream because of health. According to the second cluster, we can discover that people care about low fat dishes, which is also a reason for them to love those recipes.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure11.JPG)

In Figure 12, we discover that the third cluster correlate to the forth cluster, so we combine keywords in the third cluster with the forth cluster. Therefore, we can have more ideas and knowledge to create positive experience from “dish” recipe ontology!
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure12.JPG)

Utilizing 4 clusters we create previously to build positive experience from “Dish” recipe ontology. Besides, we can find that there are many reasons for reviewers to be satisfied with “dish” recipes, cooking again and again; therefore, we conclude with three main reasons, i.e. “Easy & Quick”, and “Tasty & Fresh”, and “Low Fat”. Figure 13 depicts positive experience from “dish” recipe ontology.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure13.JPG)

We only choose top 30 keywords for negative dialogues of “Dish”, which is different from positive dialogues (top 50 keywords); because there are less negative comments in “Dish” (49 comments; see Table 2). A total of 4 clusters are derived from bad experiences for “Dish” (Figure 14 & Figure 15). Referring to Figure 14 and Figure 15, which not give me some ideas to build an ontology; therefore, we go back to comments to discover some patterns, creating negative experience from “Dish” recipe ontology!
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure14.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure15.JPG)

Creating the ontology by comments (Figure 16), we conclude with two reasons related to negative experience from people, i.e. “Do Not Work” and “Not Tasty”. On one hand, for “Do Not Work”, which means people make some mistakes or facing with some problems when cooking; therefore, they do not like “Dish” recipes. Besides, there are three major reasons for not working: Potato is not through enough even cooking for long time and fromage frais is always split when cooking and the sauce becomes watery, which can be responsible for the mistakes of human operations. On the other hand, for “Not Tasty”, people are not always satisfied with bland color and flavor, not only for smoked paprika or some kind of meat!
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure16.JPG)

We derived 4 clusters for positive comments of “Others” (Figure 17 & Figure 18). In Figure 17 ,the third cluster shows that reviewers desire to find some recipes of baked food (e.g. cake topped with marzipan) to share with their family or friends on Christmas in the beginning of December (the time we collected data)! The forth cluster illustrates that nuts and dried fruit are one kind of the favorites for reviewers to use in “Others” recipes.
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure17.JPG)

According to Figure 18, we can discover that the first cluster correlates to the second cluster, so we can derived big picture for these two clusters; in other words, two clusters show an idea of “Breakfast”, which can be one of the favorites for reviewers. Besides, tasting sweet syrup maple or honey topping on yoghurt or granola with cranberry, which creates a wonderful morning!
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure18.JPG)

Utilizing 4 clusters we create previously to build positive experience from “Others” recipe ontology (Figure 19). Besides, for this ontology, we can find that there’re three kinds of favorites for reviewers to recommend in “Others” recipes. Firstly, in the left side of ontology, because Christmas was on the corner when collecting data, reviewers love to learn recipes of Cakes (e.g. cake topped with marzipan) to cook in Christmas party (with family or friends). Secondly, reviewers are satisfied with recipes with dried fruit or nuts or seed in the middle side of ontology. Thirdly, we can see all delicious and fresh things that reviewers like for the breakfast in the right side of ontology. 
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure19.JPG)

We only choose top 30 keywords for negative dialogues of “Others”, which is different with positive dialogues (top 50 keywords); because there are less negative comments in “Others” (32 comments; see Table 2). A total of 4 clusters were derived from bad experiences for “Others” (Figure 20 & Figure 21). Unfortunately, we cannot find any special pattern in Figure 20 and Figure 21, even if looking up all negative comments in “Others” recipes. More importantly, although picking top 30 words, they are just the frequently-used words from only one or two persons; in other words, we think there are very few people talked about same negative part for “Others” recipes. Therefore, for this part, we cannot create a complete ontology! 
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure20.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/figure21.JPG)

## 4. Discussion
According to what we did in this experiment, we kept trying to utilize different ways to see the dataset. In the beginning, we use four European regions to be our partitions; however, it showed no patterns in clusters. Furthermore, we utilized an overall angle to explore Europe recipe experience (i.e. only to see positive and negative experience for whole Europe recipes). Although we can define some clusters to see special patterns, we cannot have some special ideas for European recipe experience. As a result, we tried to partition in another way, i.e. dish and others (dessert& salad& soup), then successfully created recipe experience ontology based on reviewer comments and clustering to realize what people like and dislike for dish and others.
However, there’re some limitations for this research. Firstly, because we want to use only 200 samples (are not big samples because we cannot investigate deeply too many comments under the limited time) to see what happened in European cuisine world, we obtain very few negative comments, i.e. cannot create negative experience correctly and convincing. Therefore, for future work, we will try to use more samples or crawling more data from other U.K. recipe websites to explore U.K. people’s experience on Europe recipes! Actually, if n we aspire to use more samples to build ontology, the proportion of positive and negative comments are so unbalanced as a result of the fact that if people do not like that recipe, they won’t come back to same recipe, putting their negative comments below that recipe; in other words, scarcity of negative comments is due to the limitation of website, BBC Good Food. Although this experiment is not perfect and has some limitation, I think it still gives a way to discover something special for U.K. people’s experience of European recipes world!  Additionally, for further application, we think these results can help people to obtain some ideas to realize U.K. customers’ taste before bringing out new dishes, which can prevent dishes from failure. Besides, focusing on what people like and strengthen their satisfaction, which also can be a great thing!

## References
Ahn, Y., Ahnert, S., Bagrow, J., & Barabasi, A. (2011). Flavor network and the principles of food pairing. SCIENTIFIC REPORTS, 1-7, doi:10.1038/srep00196

Flanagan, J. C. (1954) .Critical incident technique. Psychological Bulletin, 51(4), 327-358.

Jones, K. S. (1972). A statistical interpretation of term specificity and its application in retrieval. Journal of Documentation, 28 (1), 11-20.

Luhn, H. P. (1957). A statistical approach to mechanized encoding and searching of literary information. IBM Journal of Research and Development, 1(4), 309-317.

Lee, C. C., & Hu, C. (2004). Analyzing hotel customers’ e-complaints from an Internet complaint forum. Journal of Travel and Tourism Marketing, 17(2, 3), 167-181. 

Rese, A., Schreiber, S., & Baier, D. (2014). Technology acceptance modeling of augmented reality at the point of sale: Can surveys be replaced by an analysis of online reviews? Journal of Retailing and Consumer Services, 21, 869-876.

Salton, G., & Buckley, C. (1988). Term-weighting approaches in automatic text retrieval, Journal of Information Processing and Management, 24(5), 513-523.

Sedding, J., & Kazakov, D. (2004). Wordnet-based text document clustering. 3rd Workshop on Robust Methods in Analysis of Natural Language Data, 104-113.

Teng, C.Y., Lin, Y.-R., & Adamic, L. A. (2012). Recipe recommendation using ingredient networks, Proc. 3rd Annual ACM Web Science Conference, 298-307.

Trappey, C. V., Wu, H. Y., & Liu, K. L. (2012). Knowledge discovery of customer satisfaction and dissatisfaction using ontology-based text analysis of critical incident dialogues. Proceedings of the 2012 IEEE 16th International Conference: Computer Supported Cooperative Work in Design, 470-475.

Yan, Y., & Zhang, J. (2006). Building Customer Complaint Ontology: Using OWL to Express Semantic Relations. International Conference on Management of Logistics and Supply Chain, 433-437.

## Appendix A (Dataset of Recipe Comments from Europe)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/tableA.1.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/tableA.2.JPG)

## Appendix B (Dataset of Recipe Comments by Partition with Recipe Categories)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/tableB.1.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/tableB.2.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/tableB.3.JPG)
![images](https://github.com/SuperMayLiO/Recipe-Mining/blob/master/Text%20Mining/figures/tableB.4.JPG)




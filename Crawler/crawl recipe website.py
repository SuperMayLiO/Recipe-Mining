from bs4 import BeautifulSoup
import urllib
import json
#######################################
# recipe page(comment)
#'http://www.bbcgoodfood.com/recipes/1167651/chicken-and-chorizo-jambalaya?page=2#c'
# cuisine page
#'http://www.bbcgoodfood.com/search/recipes/cuisine/vietnamese?query=&page=1'
#######################################
##### read search all data
user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
searchall='http://www.bbcgoodfood.com/search/recipes?query='
headers={'User-Agent':user_agent,} 

request=urllib.request.Request(searchall,None,headers) #The assembled request
response = urllib.request.urlopen(request)
data = response.read() # The data u need
soup=BeautifulSoup(data)
########################################
##### take out all cuisine url and name
searchall_href=[]
for link in soup.find_all('li'):
    for link2 in link.find_all('a'):
        searchall_href.append(link2.get('href'))
## url of 44 cusine 
bbcURL='http://www.bbcgoodfood.com'
searchall_url=[]
for s in searchall_href:
    if s.startswith('/search/recipes/cuisine/'):
        searchall_url.append(bbcURL+s)
## name of cuisine
cuisine_name=[]
for i in searchall_url:
    a=i.split('/')[6].split('?')[0]
    cuisine_name.append(a)
    
## number of recipe
hi=[]
for link in soup.find_all('div'):
   for link2 in link.find_all('ul'):
       for link3 in link2.find_all('li'):
          for link4 in link3.find_all('a'):
                 hi.append(link4.get_text())

recipe_number={}
for i in cuisine_name:
    for s in hi:
        if s.lower().startswith(i):
            if len(s.split("("))>1:
                recipe_number[i]=s.split("(")[1].split(')')[0]
                
recipe_number['cajun-creole']=31
recipe_number['eastern-european']=21
recipe_number['latin-american']=14
recipe_number['southern-soul']=3
recipe_number['middle-eastern']=197
recipe_number['north-african']=18
recipe_number['portugese']=6



    
########################################
## scrap
bbcgoodfood={}
#for i in range(len(cuisine_name)):
for i in range(2):
    user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
    headers={'User-Agent':user_agent,} 
    cuisine={}
    for j in range(int(recipe_number[cuisine_name[i]])//15+1):
        print('now crapping '+searchall_url[i]+'&page='+str(j)+' ...')        
        request=urllib.request.Request(searchall_url[i]+'&page='+str(j),None,headers) #The assembled request
        response = urllib.request.urlopen(request)
        data = response.read() # The data u need
        soup=BeautifulSoup(data)
        recipeurl=''
        for link in soup.find_all('h2'):
            for link2 in link.find_all('a'):
                recipeurl=bbcURL+link2.get('href')
                print('now crapping '+recipeurl+' ...')                
                request=urllib.request.Request(recipeurl,None,headers) #The assembled request
                response = urllib.request.urlopen(request)
                data2 = response.read() # The data u need
                recipesoup=BeautifulSoup(data2)
                recipe={}
                recipe['ratingvalue']=recipesoup.find(itemprop="ratingValue")['content']
                recipe['ratingnumer']=recipesoup.find(class_="rate-info").text.split('(')[1].split(' ')[0]
                try:
                    recipe['preptime']=recipesoup.find(class_="cooking-time-prep").text#.split(' ')[1]
                except AttributeError:
                    recipe['preptime']=''
                else:
                    recipe['preptime']=recipesoup.find(class_="cooking-time-prep").text#.split(' ')[1]
                try:
                    recipe['cooktime']=recipesoup.find(class_="cooking-time-cook").text#.split(' ')[1]
                except AttributeError:
                    recipe['cooktime']=''
                else:
                    recipe['cooktime']=recipesoup.find(class_="cooking-time-cook").text#.split(' ')[1]           
                recipe['skill']=recipesoup.find('span',class_="text").text
                recipe['serving']=recipesoup.find(itemprop="recipeYield").text#.split(' ')[1]
                recipe['description']=recipesoup.find(itemprop="description").text#.split(' ')[1]
                ing=[]
                for a in recipesoup.find_all(itemprop="ingredients"):
                    ing.append(a.text)
                recipe['ingredient']=ing
                recipe['nutrition']=recipesoup.find(class_="nutrition clearfix").text.split('\n')[1:-1]
                met=[]
                for b in recipesoup.find_all(itemprop="recipeInstructions"):
                    met.append(b.text.replace('\n',' '))
                recipe['method']=met
                com={}
                page=0
                while recipesoup.find(class_="username"):
                    print('now crapping comment page '+str(page)+' ...') 
                    for l in range(len(recipesoup.find_all(class_="username"))):
                        com2={}
                        com2['commentdate']=recipesoup.find_all(class_="comment-date text-style-alt")[l].text
                        com2['comment']=recipesoup.find_all(class_="field-item even")[l+1].text.replace('\n',' ').replace('\'',"'")
                        if recipesoup.find_all(class_="username")[l].parent.parent.next_sibling.next_sibling.meta:        
                            com2['commentrating']=recipesoup.find_all(class_="username")[l].parent.parent.next_sibling.next_sibling.meta['content']
                        name=recipesoup.find_all(class_="username")[l].text
                        try:
                            com[name]
                        except KeyError:
                            com[name]=com2
                        else:
                            try:
                                com[name]['re']
                            except KeyError:
                                com[name]['re']=1
                            else:
                                com[name]['re']+=1
                            e=com[name]['re']  
                            com3={}
                            for d in com2.keys():
                                print(e)
                                print(recipesoup.find_all(class_="username")[l].text)
                                print(d+'*'*e)
                                #com2[d+'*'*e]=com2.pop(d)
                                com3[d+'*'*e]=com2[d]
                                com[name].update(com3)
                                #del com2[d]
                    if len(recipesoup.find_all(class_="username"))==20:
                        page+=1
                        comurl=recipeurl+'?page='+str(page)+'#c'
                        request=urllib.request.Request(comurl,None,headers) #The assembled request
                        response = urllib.request.urlopen(request)
                        data3 = response.read() # The data u need
                        recipesoup=BeautifulSoup(data3)
                    else:
                        break
                recipe['comment']=com
                cuisine.update({recipesoup.find(itemprop="name").text:recipe})
                
    bbcgoodfood.update({cuisine_name[i]:cuisine})
    with open(cuisine_name[i]+'.json', 'w') as fp:
        json.dump(cuisine, fp)
      
bbcgoodfood['african']['Jollof rice with chicken']['comment']['kunzitch']

#10:30

###########################################  
##### take out all url recipe in all cuisine
#cuisine_each_url={}
#for i in range(len(cuisine_name)):
#    user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
#    headers={'User-Agent':user_agent,} 
#    recipehref=[]    
#    for j in range(int(recipe_number[cuisine_name[i]])//15+1):
#        request=urllib.request.Request(searchall_url[i]+'&page='+str(j),None,headers) #The assembled request
#        response = urllib.request.urlopen(request)
#        data = response.read() # The data u need
#        soup=BeautifulSoup(data)
#        for link in soup.find_all('h2'):
#            for link2 in link.find_all('a'):
#                recipehref.append(bbcURL+link2.get('href'))
#                
#    
#    for k in cuisine_name:
#        cuisine_each_url[k]=recipehref
#        
#############################################
    
    


#json.dumps(recipe, ensure_ascii=False)
 


#recipeurl='http://www.bbcgoodfood.com/recipes/1424/ken-homs-stirfried-chicken-with-chillies-and-basil'
 
#searchall='http://www.bbcgoodfood.com/recipes/1472/easy-sweet-and-sour-chicken'

    
 

    

    
    
    
    
    

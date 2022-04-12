# Instabug backend challenge


I was propmted to develop an API that enables users to create apps and get an app token by which the user can create chats and send messages. I had no prior experience with Ruby or Ruby on Rails, so building a project with that scale was kind of challenging, as I tried my best to maintain best practices while being introduced to multiple new technologies. 



# Database Design and Indexing 

I first started with 3 tables: Apps, Chats, Messages, with 1-M relationship between Apps and Chats, in addition to 1-M relationship between Chats and Messages. However, the design was changed due to 2 main factors 
  1 - Users can't get to see the ID of any entity, and therefore not being able to, for example, get messages of a chat through chat ID 
  2 - Numbering of Chats was not unique on all the Chats table but unique for a single chat, therefore users won't be able to access messages through chat number 

After analyzing the previous constraints, I linked Messages to the Apps table through app_token foreign key, while indexing chat_number for faster access of data 

I used indexing of main characterstics for each table (app_token for Apps, chat_number for chats, and messages_number and chat_number for messages table, as there were the frequently used fields in querying 


# APIs

The code includes APis for creation of Apps, which returns the app token for a provided app name. In addition, it contains APIs for creating chats and retireving all chats of a given app token. Finally, it contains APIs for creating messages, and retreiving messages through different approachs 

1- Partial matching of a query in the messages of a given chat number and app token 
2- Listing all the messages of a given chat number and app token 
3- Retrieval of a specific message through message number, chat number, and app token 

# Redis for incrementing 

In order to ensure that Chats and Messages get unique numberings, while keeping in mind to handle race conditions, I went with redis, specfically the INCR operation provided by Redis, which basically increments a value for a specific key. Since that Redis's INCR operation is atmoic, meaning that it's thread safe and takes race conditions into account, I believe it was the most suitable choice 

# Message Queuing (Rabbitmq)

In order to handle high volumes of traffic and enable asynchronous communication, using rabbitmq was a good choice in order to queue writes to database, I used it for cirtical insertions, such as New chats and New messages. My message queuing logic included a worker that has 2 queues, one for each table. When a publisher recieves an object to be queued, it recieves as well a string that indicates whether it's a message or a chat, which afterwards facilitates in using which queue to queue the recievied object 

# Elasticsearch 

As promopted, I used elasticsearch in order to enable searching among messages with a given keyword (Partial matching). As it was my first encounter ever with elasticsearch, I started first with the basic wildcard option, a strong and accurate option yet not scalable enough in general situations, like matching queries that includes more than 1 word. After further research, I found a quick tutorial provided by elasticsearch about Ngrams approach, which was suitable for the given situation. 

As Elasticsearch takes more time to start working, I used the wait-for-it.sh, which includes a bash script provided by docker in cases where containers depend on the startup of one another 

# Docker 

The application is containerized using docker, with all needed commands called while the container is starting. All you need to do is to run ```docker-compose up --build``` 

## IMPORTANT NOTE

Because some images weren't compatible with M1, I had to specify a linux platform for some of the services running. Therefore, please check that both shell scripts in the repo has Unix EOF format if testing the code on a windows machine  


# Request and response examples 

1) App Creation 
<img width="897" alt="image" src="https://user-images.githubusercontent.com/52424727/162794729-fcdfb2db-1631-418f-8371-8ca29d40024a.png">

2) Chat Creation  (Note that App token is sent in the headers) 
<img width="547" alt="image" src="https://user-images.githubusercontent.com/52424727/162794917-8a92900c-02d6-46c9-9fc9-6a14bf6d1f48.png">

3) Message Creation 1
<img width="721" alt="image" src="https://user-images.githubusercontent.com/52424727/162795113-c3165b8a-aae0-46e8-9c41-dc13f5aa7f3d.png">

4) Message Creation 2
<img width="721" alt="image" src="https://user-images.githubusercontent.com/52424727/162795169-d0c2f8f3-5c21-4bc5-8a6d-4404d870b179.png">

5) Listing Messages 
<img width="826" alt="image" src="https://user-images.githubusercontent.com/52424727/162795253-9c22ef9a-42f4-4390-8e7d-c89d47bf4841.png">

6) Partial Matching 
<img width="827" alt="image" src="https://user-images.githubusercontent.com/52424727/162795397-e8098bad-4196-4da8-abb6-12031facfc46.png">



# Postman Collection 

[Click Here!](https://github.com/SeifEldinHani/Instabug_backend_challenge/blob/main/Instabug%20Task%20Collection.postman_collection.json)

# References 
[Redis Increment](https://redis.io/commands/incr/)<br/>
[Elasticsearch Ngram Analyzer](https://www.elastic.co/guide/en/elasticsearch/guide/current/ngrams-compound-words.html)<br/>
[Rabbitmq Ruby Documentation](https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html)<br/>
[Docker wait for it guide](https://docs.docker.com/compose/startup-order/)

Домашнее задание  
MongoDB  

Цель:  
Научиться разворачивать MongoDB, заполнять данными и делать запросы.  

Описание/Пошаговая инструкция выполнения домашнего задания:  
Необходимо:  

установить MongoDB одним из способов: ВМ, докер;  
заполнить данными;  
написать несколько запросов на выборку и обновление данных  

Сдача ДЗ осуществляется в виде миниотчета.  

___________________________________________________________________________________________________  

Задание повышенной сложности*  

создать индексы и сравнить производительность.  

Критерии оценки:  
задание выполнено - 10 баллов  
предложено красивое решение - плюс 2 балла  
предложено рабочее решение, но не устранены недостатки, указанные преподавателем - минус 2 балла  
плюс 5 баллов за задание со звездочкой*  

Решение:  
1. Установить MongoDB одним из способов: ВМ, докер:  
MongoDB установлена в на VM  
![mongo_unstall](https://github.com/thornix/otus_dba/blob/main/hw21_basic_mongodb_features/mongo_unstall.png)

2. Заполнить данными:   
Данные взяты из [https://github.com/ozlerhakan/mongodb-json-files](https://github.com/ozlerhakan/mongodb-json-files)
![data_set](https://github.com/thornix/otus_dba/blob/main/hw21_basic_mongodb_features/data_set.png)  

3. Написать несколько запросов на выборку и обновление данных:  
```
db.books.find({'_id': 1})
db.books.updateOne({'_id': 1},{$set:{pageCount: 417}})
```
![set](https://github.com/thornix/otus_dba/blob/main/hw21_basic_mongodb_features/set.jpg)    

```
db.books.insertOne({
    title: 'Evgeniy Onegin',
    isbn: '5675674567',
    pageCount: 100,
    publishedDate: ISODate('1825-02-18T07:00:00.000Z'),
    thumbnailUrl: 'https://google.com',
    longDescription: `And to live in a hurry and to feel in a hurry`,
    status: 'PUBLISH',
    authors: [ 'Alexander Pushkin' ],
    categories: [ 'poem in verse', 'fiction' ]
})
db.books.deleteOne({"title": "Evgeniy Onegin"})
```
![result](https://github.com/thornix/otus_dba/blob/main/hw21_basic_mongodb_features/result.png)  


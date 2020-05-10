import pymongo as pm
import pandas as pd

# some usefull libraries
def head(cursor, n = 3):
    hd = list(cursor.limit(n))
    print(hd)

def printer(lst):
        pd.set_option('max_colwidth', 100)
        df = pd.DataFrame({})
        keys = lst[0].keys()
        values = [list(i.values()) for i in lst]
        for key, col in zip(keys, range(len(keys))):
                df[key] = [i[col] for i in values]
        print(df)


# Connecting to mongo
uri = 'mongodb://127.0.0.1:27017'
client = pm.MongoClient(uri)
print('Connection stablished...', '\n')

# Selecting database and collections
db = client['dblp']
a = 'autores'
p = 'publicaciones'

head(db.publicaciones.find(), 1)
head(db.autores.find(), 3)


# Query 01
pipe = [{'$match': {'author': 'A-Nasser Ansari'}},
        {'$project': {'_id': 0, 'title': 1}}]

print('\n', 'QUERY 01:')
query_anasari = db.publicaciones.aggregate(pipe, allowDiskUse = True)
printer(list(query_anasari))


# Query 02
pipe = [{'$match': {'author': 'A-Nasser Ansari'}},
        {'$project': {'_id': 0, 'title': 1}},
        {'$count': 'Anasari_publications'}]

print('\n', 'QUERY 02:')
query_anasari_n = db.publicaciones.aggregate(pipe, allowDiskUse = True)
print(list(query_anasari_n))


# Query 03
pipe = [{'$match': {'branch': 'article', 'year': '2018'}},
        {'$count': 'Articles_2018'}]

print('\n', 'QUERY 03:')
query_revista_2018 = db.publicaciones.aggregate(pipe, allowDiskUse = True)
print(list(query_revista_2018))


# Query 04
pipe = [{'$unwind': '$publications'},
        {'$project': {'_id': '$_id', 'n_publications': {'$sum': 1}}},
        {'$match': {'n_publications': {'$lt': 5}}},
        {'$count': 'Authors < 5 publications'}]

print('\n', 'QUERY 04:')
query_autores_5 = db.autores.aggregate(pipe, allowDiskUse = True)
print(list(query_autores_5))


# Query 05
pipe = [{'$project': {'_id': '$_id', 'n_publications': {'$size': '$publications'}, 'publications': '$publications'}},
        {'$sort': {'n_publications': -1}},
        {'$limit': 11},
        {'$unwind': '$publications'},
        {'$lookup':{'from': 'publicaciones','localField': 'publications', 'foreignField': '_id', 'as': 'document'}},
        {'$project': {'_id': '$_id', 'type': '$document.branch'}},
        {'$unwind': '$type'}, {'$unwind': '$type'},
        {'$match': {'$or': [{'type': 'article'}, {'type': 'inproceedings'}]}},
        {'$group': {'_id': '$type', 'n': {'$sum': 1}}}]

print('\n', 'QUERY 05:')
query_autores_10 = db.autores.aggregate(pipe, allowDiskUse = True)
printer(list(query_autores_10))


# Query 06
pipe = [{'$unwind': '$author'},
        {'$group': {'_id': {'id': '$_id', 'branch': '$branch'}, 'n_authors': {'$sum': 1}}},
        {'$project': {'_id': '$_id.id', 'branch': '$_id.branch', 'n_authors': '$n_authors'}},
        {'$group': {'_id': '$branch', 'avg_authors': {'$avg': '$n_authors'}}}]

print('\n', 'QUERY 06:')
query_autores_5 = db.publicaciones.aggregate(pipe, allowDiskUse = True)
printer(list(query_autores_5))


# Query 07
pipe = [{'$unwind': '$publications'},
        {'$match': {'_id': 'A-Nasser Ansari'}},
        {'$lookup': {'from': 'publicaciones', 'localField': 'publications', 'foreignField': '_id', 'as': 'document'}},
        {'$project': {'_id': '$_id', 'coauthor': '$document.author'}},
        {'$unwind': '$coauthor'},
        {'$unwind': '$coauthor'},
        {'$match': {'coauthor': {'$ne': 'A-Nasser Ansari'}}},
        {'$group': {'_id': '$_id', 'coauthor': {'$addToSet': '$coauthor'}}}]

print('\n', 'QUERY 07:')
query_coautores = db.autores.aggregate(pipe, allowDiskUse = True)
print(list(query_coautores))


# Query 08
pipe = [{'$unwind': '$publications'},
        {'$lookup':{'from': 'publicaciones', 'localField': 'publications', 'foreignField': '_id', 'as': 'document'}},
        {'$project': {'_id': '$_id', 'year': '$document.year'}},
        {'$unwind': '$year'}, {'$unwind': '$year'},
        {'$limit': 10000},
        {'$group': {'_id': '$_id', 'max_year': {'$max': '$year'}, 'min_year': {'$min': '$year'}}},
        {'$project': {'_id': '$_id', 'age': {'$subtract': [{'$toInt': '$max_year'}, {'$toInt': '$min_year'}]}}},
        {'$sort': {'age': -1}},
        {'$limit': 5}]

print('\n', 'QUERY 08:')
query_age = db.autores.aggregate(pipe, allowDiskUse = True)
printer(list(query_age))


# Query 09
pipe = [{'$unwind': '$publications'},
        {'$lookup':{'from': 'publicaciones', 'localField': 'publications', 'foreignField': '_id', 'as': 'document'}},
        {'$project': {'_id': '$_id', 'year': '$document.year'}},
        {'$unwind': '$year'}, {'$unwind': '$year'},
        {'$limit': 10000},
        {'$group': {'_id': '$_id', 'max_year': {'$max': '$year'}, 'min_year': {'$min': '$year'}}},
        {'$project': {'_id': '$_id', 'age': {'$subtract': [{'$toInt': '$max_year'}, {'$toInt': '$min_year'}]}}},
        {'$match': {'age': {'$lt': 5}}},
        {'$count': 'Novels authors'}]

print('\n', 'QUERY 09:')
query_novels = db.autores.aggregate(pipe, allowDiskUse = True)
print(list(query_novels))


# Query 10
pipe = [{'$project': {'_id': '1', 'magazines': {'$cond': [{'$eq': ['$branch', ['article']]}, 1, 0]}}},
        {'$group': {'_id': '$_id', 'total_magazines': {'$sum': '$magazines'}, 'total_docs': {'$sum': 1}}},
        {'$project': {'Magazines percentage':
                              {'$round': [{'$multiply': [{'$divide': ['$total_magazines', '$total_docs']}, 100]}, 0]}}}]

print('\n', 'QUERY 10:')
query_novels = db.publicaciones.aggregate(pipe, allowDiskUse = True)
print(list(query_novels))
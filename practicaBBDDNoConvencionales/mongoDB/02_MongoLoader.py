import pymongo as pm
import json

def load_json(path, db, collection = 'test'):
    collection = db[collection]
    with open(path, 'r') as handle:
        for line in handle:
            data = json.loads(line)
            collection.insert_one(data)
    client.close()

def head(cursor, n = 3):
    hd = list(cursor.limit(n))
    print(hd)


# Connecting to mongo
uri = 'mongodb://127.0.0.1:27017'
client = pm.MongoClient(uri)
print('Connection stablished...')

# Creating database
db = client['dblp']
collection = 'publicaciones'
print('Database created')

# load database from json
json_path = 'dblp_parsed.json'
load_json(json_path, db, collection)
print('Database loaded')

# Show new db Articles
print('\n', 'These are the databse stored:')
print(client.database_names())
print('\n', 'These are the collections inside db selected')
print(db.list_collection_names())

# Show items inside collection
print('\n', 'Showing the head of the database:')
head(db.publicaciones.find())
print('\n', 'Number of items loaded: ')
print(db.publications.find().count())

# Creating new collection authors
pipe_authors = [{"$unwind": "$author"},
           {"$group": {"_id": "$author","publications": {"$push": "$_id"}}},
           {'$out': "autores"}]
db.publicaciones.aggregate(pipe_authors,  allowDiskUse = True)
print('\n', 'Collections created')


print('\n', 'These are the collections inside db selected')
print(db.list_collection_names())
print('\n','Process ended')

# Erase collections
# db.publicaciones.drop(), db.autores.drop()
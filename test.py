import os
import rethinkdb as r

print os.getenv('MASTER_IP')
print os.getenv('MASTER_PORT')
print os.getenv('SLAVE2_IP')
print os.getenv('SLAVE2_PORT')

print 'connecting and listing databases'

conn = r.connect(os.getenv('MASTER_IP'), os.getenv('MASTER_PORT')).repl()
print r.db_list().run(conn)
print conn.host

print 'creating database'

r.db_create('wercker_tutorial').run(conn)

print 'creating table'

r.db('wercker_tutorial').table_create('decepticons').run(conn)

print 'inserting decepticons'
r.db('wercker_tutorial').table('decepticons').insert({
      "decepticon": "Devastator",
      "team": "Constructicons",
      "members": ["Scrapper","Hook","Bonecrusher","Scavenger","Long Haul","Mixmaster"]
    }).run(conn)

print "doing stuff on the second slave..."
conn2 = r.connect(os.getenv('SLAVE2_IP'), 28015).repl()
print conn2.host
print r.db_list().run(conn2)
result = r.db('wercker_tutorial').table('decepticons').run(conn2)
for i in result:
  print i

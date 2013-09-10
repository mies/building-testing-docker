import os
import rethinkdb as r

print 'Set up connection'

conn = r.connect(os.getenv('MASTER_IP'), os.getenv('MASTER_PORT')).repl()
print conn.host

print 'Creating database'

r.db_create('wercker_tutorial').run(conn)

print 'creating table'

r.db('wercker_tutorial').table_create('decepticons').run(conn)

print 'Inserting data'
r.db('wercker_tutorial').table('decepticons').insert({
      "decepticon": "Devastator",
      "team": "Constructicons",
      "members": ["Scrapper","Hook","Bonecrusher","Scavenger","Long Haul","Mixmaster"]
    }).run(conn)

print "Fetching data from the second slave..."
conn2 = r.connect(os.getenv('SLAVE2_IP'), 28015).repl()
print conn2.host

result = r.db('wercker_tutorial').table('decepticons').run(conn2)
for i in result:
  print i

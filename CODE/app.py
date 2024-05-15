from flask import Flask, render_template, redirect, url_for
import psycopg2

app = Flask(__name__)

#Database Configuration
DB_NAME = 'test'
DB_USER = 'lion'
DB_PASSWORD = 'lion'
DB_HOST = 'localhost'
DB_PORT = '5432'

# Connect to the database
def connect_to_db():
	conn = psycopg2.connect(
    	dbname=DB_NAME,
    	user=DB_USER,
    	password=DB_PASSWORD,
    	host=DB_HOST,
    	port=DB_PORT
	)
	return conn

# Route for the home page
@app.route('/')
def home():
	return render_template('index.html')

# Route to display the Family_Tree view
@app.route('/family_tree')
def display_family_tree():
	conn = connect_to_db()
	cur = conn.cursor()
	cur.execute("SELECT * FROM Family_Tree")
	data = cur.fetchall()
	conn.close()
	return render_template('family_tree.html', data=data)

if __name__ == '__main__':
	app.run(debug=True)





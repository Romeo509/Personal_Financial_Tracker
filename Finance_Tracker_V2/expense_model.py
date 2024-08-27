from datetime import datetime
from flask import g
import mysql.connector

DATABASE = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'personal_financial_tracker'
}

def get_db():
    if 'db' not in g:
        g.db = mysql.connector.connect(**DATABASE)
    return g.db

def close_db(e=None):
    db = g.pop('db', None)
    if db is not None:
        db.close()

def create_tables():
    db = get_db()
    cursor = db.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255) NOT NULL UNIQUE,
            email VARCHAR(255) NOT NULL UNIQUE,
            password VARCHAR(255) NOT NULL
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS expenses (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            category VARCHAR(255) NOT NULL,
            amount DECIMAL(10, 2) NOT NULL,
            date DATE NOT NULL,
            is_deleted BOOLEAN DEFAULT FALSE,
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    ''')
    db.commit()

def create_user(username, email, password):
    db = get_db()
    cursor = db.cursor()
    cursor.execute("INSERT INTO users (username, email, password) VALUES (%s, %s, %s)", (username, email, password))
    db.commit()

def get_user(username):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT id, password FROM users WHERE username = %s", (username,))
    return cursor.fetchone()

def add_expense(user_id, category, amount, date):
    db = get_db()
    cursor = db.cursor()
    cursor.execute("INSERT INTO expenses (user_id, category, amount, date) VALUES (%s, %s, %s, %s)", (user_id, category, amount, date))
    db.commit()

def get_expenses(user_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT id, category, amount, date FROM expenses WHERE user_id = %s AND is_deleted = FALSE", (user_id,))
    return cursor.fetchall()

def delete_expense(expense_id, user_id):
    db = get_db()
    cursor = db.cursor()
    cursor.execute("UPDATE expenses SET is_deleted = TRUE WHERE id = %s AND user_id = %s", (expense_id, user_id))
    db.commit()

def restore_expenses(user_id):
    db = get_db()
    cursor = db.cursor()
    cursor.execute("UPDATE expenses SET amount = 0, date = %s, is_deleted = FALSE WHERE user_id = %s", (datetime.now().strftime('%Y-%m-%d'), user_id))
    db.commit()

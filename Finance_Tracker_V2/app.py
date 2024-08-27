from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Change this to a random secret key

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="personal_financial_tracker"  # Update with your database name
)

@app.route('/')
def index():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    cursor = db.cursor()
    cursor.execute("SELECT * FROM expenses WHERE user_id = %s AND is_deleted = FALSE", (session['user_id'],))
    expenses = cursor.fetchall()
    cursor.close()

    return render_template('dashboard.html', expenses=expenses)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        hashed_password = generate_password_hash(password)  # Use default method

        cursor = db.cursor()
        try:
            cursor.execute("INSERT INTO users (username, email, password) VALUES (%s, %s, %s)", (username, email, hashed_password))
            db.commit()
            flash('Account created successfully. Please log in.', 'success')
            return redirect(url_for('login'))
        except mysql.connector.Error as err:
            flash(f'Error: {err}', 'danger')
        finally:
            cursor.close()

    return render_template('signup.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor = db.cursor()
        cursor.execute("SELECT id, password FROM users WHERE username = %s", (username,))
        user = cursor.fetchone()
        cursor.close()

        if user and check_password_hash(user[1], password):
            session['user_id'] = user[0]
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password.', 'danger')

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('login'))

@app.route('/add_expense', methods=['POST'])
def add_expense():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    category = request.form['category']
    amount = request.form['amount']
    date = request.form['date']

    cursor = db.cursor()
    cursor.execute("INSERT INTO expenses (user_id, category, amount, date) VALUES (%s, %s, %s, %s)", (session['user_id'], category, amount, date))
    db.commit()
    cursor.close()

    return redirect(url_for('manage_expenses'))

@app.route('/delete_expense/<int:expense_id>', methods=['POST'])
def delete_expense(expense_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cursor = db.cursor()
    cursor.execute("UPDATE expenses SET is_deleted = TRUE WHERE id = %s AND user_id = %s", (expense_id, session['user_id']))
    db.commit()
    cursor.close()

    return redirect(url_for('manage_expenses'))

@app.route('/manage_expenses')
def manage_expenses():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cursor = db.cursor()
    cursor.execute("SELECT * FROM expenses WHERE user_id = %s AND is_deleted = FALSE", (session['user_id'],))
    expenses = cursor.fetchall()
    cursor.close()

    return render_template('manage_expenses.html', expenses=expenses)

@app.route('/history')
def history():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('history.html')

@app.route('/account', methods=['GET', 'POST'])
def account():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cursor = db.cursor()
    if request.method == 'POST':
        new_username = request.form['username']
        new_email = request.form['email']
        new_password = request.form['password']

        if new_password:
            hashed_password = generate_password_hash(new_password)
            cursor.execute("UPDATE users SET username = %s, email = %s, password = %s WHERE id = %s", (new_username, new_email, hashed_password, session['user_id']))
        else:
            cursor.execute("UPDATE users SET username = %s, email = %s WHERE id = %s", (new_username, new_email, session['user_id']))

        db.commit()
        cursor.close()

        flash('Account updated successfully.', 'success')
        return redirect(url_for('account'))

    # Fetch current user details
    cursor.execute("SELECT username, email FROM users WHERE id = %s", (session['user_id'],))
    user = cursor.fetchone()
    cursor.close()

    return render_template('account.html', user=user)


if __name__ == '__main__':
    app.run(debug=True)

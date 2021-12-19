from sqlalchemy import text


class UserDao:
    def __init__(self, database):
        self.db = database

    def search_duplicate_user(self, user):
        user_id = self.db.execute(
            text(
                """
                SELECT email
                FROM users
                WHERE email = :email
                """
            ),
            user,
        )
        return user_id

    def insert_user(self, user):
        user_id = self.db.execute(
            text(
                """
                INSERT INTO users (
                    email, password
                ) VALUES (
                    :email, :password
                )
                """
            ),
            user,
        )
        return user_id

    def login_user(self, user):
        user_login = self.db.execute(
            text(
                """
                SELECT email, password
                FROM users
                WHERE email = :email AND
                password = :password
                """
            ),
            user,
        )
        return user_login

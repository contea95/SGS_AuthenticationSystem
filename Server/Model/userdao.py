from sqlalchemy import text
import bcrypt


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
        crypt_user_password_byte = bcrypt.hashpw(
            user["password"].encode("utf-8"), bcrypt.gensalt()
        )
        crypt_user_password_str = crypt_user_password_byte.decode("utf-8")
        # print(type(crypt_user_password_str))
        user["password"] = crypt_user_password_str
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
                SELECT email, password, role
                FROM users
                WHERE email = :email
                """
            ),
            user,
        )
        return user_login

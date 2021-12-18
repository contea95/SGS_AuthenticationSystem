from model.userdao import UserDao


class UserService:
    def __init__(self, userdao):
        self.userdao = userdao

    def create_new_user(self, new_user):
        user = self.userdao.insert_user(new_user)
        return user

    def login_user(self, login_user):
        user = self.userdao.login_user(login_user)
        return user

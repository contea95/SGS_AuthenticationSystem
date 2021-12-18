from flask import Flask
from sqlalchemy import create_engine
from model.userdao import UserDao
from controller.user_service import UserService
from router.add_user.add_user import create_adduser_endpoint
from router.login_user.login_user import create_loginuser_endpoint


class Services:
    pass


def create_app():
    # 앱 설정
    app = Flask(__name__)
    app.config.from_pyfile("config.py")

    app.database = dbconnection(app)

    user_dao = UserDao(app.database)

    services = Services
    services.user_service = UserService(user_dao)

    # api = Api(app)
    create_adduser_endpoint(app, services)
    create_loginuser_endpoint(app, services)
    return app


def dbconnection(flask_app: Flask):
    database = create_engine(flask_app.config["DB_URL"], encoding="utf-8")
    return database

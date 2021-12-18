from flask import Flask  # 서버 구현을 위한 Flask 객체
from flask_restx import Api, Resource  # Api 구현을 위한 Api 객체
from todo import Todo


app = Flask(__name__)  # Flask 객체 선언
api = Api(app)  # Flask 객체에 Api 등록


api.add_namespace(Todo, "/todos")


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)

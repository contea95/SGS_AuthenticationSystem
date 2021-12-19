import bcrypt
import jwt
from flask import request, jsonify


def create_loginuser_endpoint(app, services):
    user_service = services.user_service

    @app.route("/loginuser", methods=["POST"])
    def login():
        try:
            # 유저가 입력한 이메일, 패스워드 json
            user = request.json

            # 비교를 위한 이메일, 패스워드 저장
            user_input_email = user["email"]
            user_input_password = user["password"]

            # 로그인 모듈 실행
            user = user_service.login_user(user)
            db_user_list = user.all()
            if db_user_list:
                count = 0
                # DB 저장된 유저 정보
                for row in db_user_list:
                    for i in row:
                        if count == 0:
                            db_user_email = i
                            count += 1
                        elif count == 1:
                            db_user_password = i
                            count += 1
                        else:
                            db_user_role = i
                if user_input_email == db_user_email:
                    if bcrypt.checkpw(
                        user_input_password.encode("utf-8"),
                        db_user_password.encode("utf-8"),
                    ):
                        if db_user_role == "admin":
                            return {
                                "Authorization": jwt.encode(
                                    {
                                        "email": db_user_email,
                                        "password": db_user_password,
                                        "role": db_user_role,
                                    },
                                    "secret",
                                    algorithm="HS256",
                                ).decode("utf-8")
                            }, 200
                        else:
                            return {"message": "UserLogin"}, 200
                    else:
                        return {"message": "Auth Failed"}, 500
                else:
                    return {"message": "User Not Found"}, 404
            else:
                return jsonify("login error"), 404
        except Exception as e:
            return {"login error": str(e)}, 401

    @app.route("/get")
    def get():
        header = request.headers.get("Authorization")
        if header == None:
            return {"message": "Please Login"}, 404
        data = jwt.decode(header, "secret", algorithms="HS256")
        return data, 200

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
                            print("db email", db_user_email)
                        else:
                            db_user_password = i
                            print("db password", db_user_password)
                if (
                    user_input_email == db_user_email
                    and user_input_password == db_user_password
                ):
                    return jsonify("로그인 완료"), 200
                # elif user_input_email != db_user_email:
                #     return jsonify("이메일이 틀렸습니다."), 401
                # elif (
                #     user_input_email == db_user_email
                #     and user_input_password != db_user_password
                # ):
                #     return jsonify("비밀번호가 틀렸습니다."), 401
            else:
                return jsonify("login error"), 401
            return "", 200
        except Exception as e:
            return {"login error": str(e)}, 401

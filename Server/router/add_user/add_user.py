from flask import request, jsonify


def create_adduser_endpoint(app, services):
    user_service = services.user_service

    @app.route("/adduser", methods=["POST"])
    def sign_up():
        try:
            user = request.json
            # 유저 아이디 중복 확인하기
            if user_service.search_user(user).all():
                return jsonify("동일한 이메일이 있습니다."), 409
            else:
                user = user_service.create_new_user(user)
                return jsonify("회원가입 완료"), 200
        except Exception as e:
            return {"sign_up error": str(e)}

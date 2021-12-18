from flask import request


def create_adduser_endpoint(app, services):
    user_service = services.user_service

    @app.route("/adduser", methods=["POST"])
    def sign_up():
        try:
            user = request.json
            user = user_service.create_new_user(user)
            return "", 200
        except Exception as e:
            return {"sign_up error": str(e)}

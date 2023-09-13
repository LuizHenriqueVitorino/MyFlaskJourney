from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

# Rota de login simulada
@app.route('/auth/login', methods=['POST'])
def mock_login():
    # return jsonify({'message': 'Login bem-sucedido (simulado)'}), 200
    data = request.get_json()

    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify(
            {
                "statusCode": 400,
                "name": "error",
                "message": "login failed"
            }
            ), 400

    # Simulando uma autenticação bem-sucedida
    return jsonify(
        {
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
            "ttl": 1209600,
            "created": datetime.now(),
            "userId": "646e6ce286a5a138a515e0b6"
        }
        ), 200

#rota de logout simulado
@app.route('/auth/logout', methods=['DELETE'])
def mock_logout():
    # pega o argumento token na quarry e armazena na variável token_param
    token_param = request.args.get('token')

    # se o token estiver vazio, retorna um json com uma mensagem de erro
    if not token_param:
        return jsonify(
            {
                "statusCode": 498,
                "name": "error",
                "message": "Invalid, non-existent or empty token"
            }
        ), 498

    # se estiver tudo certo, retorna um código 200 com uma mensagem
    return jsonify(
        {
            "statusCode": 200,
            "message": "successfully canceled token"
        }
    ), 200

    
if __name__ == '__main__':
    app.run(debug=True)

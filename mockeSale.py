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

# Rota de logout simulado
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

@app.route('/leaflet/predictOffer', methods=['POST'])
def leaflet_predictOffer():
    # Pega o teken e o leafle do reader e armazana-os em variáveis
    token   = request.headers.get('token')
    leaflet = request.headers.get('leaflet')

    # Se o token ou o leaflet estiver em branco, então retorna uma mensagem de erro
    if not token or not leaflet:
        return jsonify(
            {
                "statusCode": 422,
                "name": "error",
                "message": "request has fields empties"
            }
        ), 422
    
    # Se tudo ocorrer bem, então retorna um json com os produtos e o código 200
    return jsonify(
        {
                "leaflet_id": "6453bacbb6fed22ec5c1cd1e",
                "request": [
                    {
                    "item_id": "56902796e33b5b9c565aa5ab",
                    "product_id": "646cd32304ea8423670cafde",
                    "value": 8.49,
                    "dynamic": "OFERTA_DE_POR",
                    "minimum_quantity": 1
                    }
                ],
                "unidentified_leaflet_items_ids": [
                    "56902796e33b5b9c565aa5ab"
                ]
            }
    ), 200


if __name__ == '__main__':
    app.run(debug=True)

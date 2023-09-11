from flask import Flask, request, jsonify

app = Flask(__name__)

# Rota de login simulada
@app.route('/login', methods=['POST'])
def mock_login():
    data = request.get_json()

    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'message': 'Usuário e senha são obrigatórios'}), 400

    # Simulando uma autenticação bem-sucedida
    return jsonify({'message': 'Login bem-sucedido (simulado)'}), 200

if __name__ == '__main__':
    app.run(debug=True)

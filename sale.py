from flask import Flask
app = Flask(__name__)

@app.route('/login/', methods=['POST'])
def login():
    pass

@app.route('/logout/', methods=['DELETE'])
def logout():
    pass

@app.route('leaflet/predictOffers', methods=['POST'])
def leaflet():
    pass
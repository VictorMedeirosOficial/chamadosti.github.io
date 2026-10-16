# -*- coding: utf-8 -*-
"""
============================================================================
SERVIDOR PYTHON (FLASK + MYSQL) PRÉ-CONFIGURADO PARA LOCALHOST E REDE LOCAL
============================================================================
Como rodar:
  1. pip install -r requirements.txt
  2. python server.py
  3. Acesse: http://localhost:3000
"""

import json
import socket
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import mysql.connector

app = Flask(__name__, static_folder='.')
CORS(app)

DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',
    'database': 'helpdesk_ti'
}

def get_db_connection():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory('.', path)

@app.route('/api/status', methods=['GET'])
def api_status():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({'ok': True, 'mysql': True, 'host': DB_CONFIG['host'], 'database': DB_CONFIG['database'], 'msg': 'Conectado ao MySQL via Python Flask!'})
    except Exception as e:
        return jsonify({'ok': False, 'mysql': False, 'error': str(e)}), 500

@app.route('/api/sincronizar', methods=['POST'])
def api_sincronizar():
    try:
        data = request.json or {}
        chamados = data.get('chamados', [])
        colaboradores = data.get('colaboradores', [])
        perfil = data.get('perfilTI')

        conn = get_db_connection()
        cursor = conn.cursor()

        if perfil:
            cursor.execute(
                "UPDATE configuracoes_ti SET nome_tecnico=%s, cargo_tecnico=%s, ramal_tecnico=%s, foto_ti=%s WHERE id=1",
                (perfil.get('nome', 'Lucas Silva'), perfil.get('cargo', 'Analista de Suporte TI'), perfil.get('ramal', '2044'), perfil.get('foto'))
            )

        for col in colaboradores:
            cursor.execute(
                """INSERT INTO colaboradores (id, nome, funcao, setor, ramal, cor_badge)
                   VALUES (%s, %s, %s, %s, %s, %s)
                   ON DUPLICATE KEY UPDATE nome=VALUES(nome), funcao=VALUES(funcao), setor=VALUES(setor), ramal=VALUES(ramal)""",
                (col.get('id'), col.get('nome'), col.get('funcao', 'Ajudante'), col.get('setor', 'TI'), col.get('ramal', ''), col.get('cor', 'blue'))
            )

        for c in chamados:
            cursor.execute(
                """INSERT INTO chamados (id, setor, responsavel, categoria, urgencia, descricao, status, resultado, parecer_tecnico, ajudantes_json, comentarios_json, data_abertura, data_resolucao)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                   ON DUPLICATE KEY UPDATE
                     status=VALUES(status), resultado=VALUES(resultado), parecer_tecnico=VALUES(parecer_tecnico),
                     ajudantes_json=VALUES(ajudantes_json), comentarios_json=VALUES(comentarios_json), data_resolucao=VALUES(data_resolucao)""",
                (
                    c.get('id'), c.get('setor'), c.get('responsavel'), c.get('categoria'),
                    c.get('urgencia', 'Normal'), c.get('descricao', ''), c.get('status', 'aberto'),
                    c.get('resultado'), c.get('parecerTecnico', ''),
                    json.dumps(c.get('ajudantes', []), ensure_ascii=False),
                    json.dumps(c.get('comentarios', []), ensure_ascii=False),
                    c.get('dataAbertura'), c.get('dataResolucao')
                )
            )

        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'ok': True, 'msg': 'Sincronizado com MySQL com sucesso!'})
    except Exception as e:
        return jsonify({'ok': False, 'error': str(e)}), 500

if __name__ == '__main__':
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    print("====================================================================")
    print(f"🚀 Servidor Python/Flask + MySQL rodando!")
    print(f"💻 Localhost:   http://localhost:3000")
    print(f"🌐 Rede Local:  http://{local_ip}:3000")
    print("====================================================================")
    app.run(host='0.0.0.0', port=3000, debug=True)
```[cite: 3]

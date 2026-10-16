# -*- coding: utf-8 -*-
"""
============================================================================
SERVIDOR PYTHON (FLASK + MYSQL) PRÉ-CONFIGURADO PARA LOCALHOST E REDE LOCAL
============================================================================
Como rodar:
  1. pip install -r requirements.txt
  2. python server.py
  3. Acesse: http://localhost:3000
"""[cite: 1]

import json[cite: 1]
import socket[cite: 1]
from flask import Flask, request, jsonify, send_from_directory[cite: 1]
from flask_cors import CORS[cite: 1]
import mysql.connector[cite: 1]

app = Flask(__name__, static_folder='.')[cite: 1]
CORS(app)[cite: 1]

DB_CONFIG = {[cite: 1]
    'host': 'localhost',[cite: 1]
    'port': 3306,[cite: 1]
    'user': 'root',[cite: 1]
    'password': '',[cite: 1]
    'database': 'helpdesk_ti'[cite: 1]
}

def get_db_connection():[cite: 1]
    return mysql.connector.connect(**DB_CONFIG)[cite: 1]

@app.route('/')[cite: 1]
def index():[cite: 1]
    return send_from_directory('.', 'index.html')[cite: 1]

@app.route('/<path:path>')[cite: 1]
def static_files(path):[cite: 1]
    return send_from_directory('.', path)[cite: 1]

@app.route('/api/status', methods=['GET'])[cite: 1]
def api_status():[cite: 1]
    try:[cite: 1]
        conn = get_db_connection()[cite: 1]
        conn.close()[cite: 1]
        return jsonify({'ok': True, 'mysql': True, 'host': DB_CONFIG['host'], 'database': DB_CONFIG['database'], 'msg': 'Conectado ao MySQL via Python Flask!'})[cite: 1]
    except Exception as e:[cite: 1]
        return jsonify({'ok': False, 'mysql': False, 'error': str(e)}), 500[cite: 1]

@app.route('/api/sincronizar', methods=['POST'])[cite: 1]
def api_sincronizar():[cite: 1]
    try:[cite: 1]
        data = request.json or {}[cite: 1]
        chamados = data.get('chamados', [])[cite: 1]
        colaboradores = data.get('colaboradores', [])[cite: 1]
        perfil = data.get('perfilTI')[cite: 1]

        conn = get_db_connection()[cite: 1]
        cursor = conn.cursor()[cite: 1]

        if perfil:[cite: 1]
            cursor.execute([cite: 1]
                "UPDATE configuracoes_ti SET nome_tecnico=%s, cargo_tecnico=%s, ramal_tecnico=%s, foto_ti=%s WHERE id=1",[cite: 1]
                (perfil.get('nome', 'Lucas Silva'), perfil.get('cargo', 'Analista de Suporte TI'), perfil.get('ramal', '2044'), perfil.get('foto'))[cite: 1]
            )[cite: 1]

        for col in colaboradores:[cite: 1]
            cursor.execute([cite: 1]
                """INSERT INTO colaboradores (id, nome, funcao, setor, ramal, cor_badge)
                   VALUES (%s, %s, %s, %s, %s, %s)
                   ON DUPLICATE KEY UPDATE nome=VALUES(nome), funcao=VALUES(funcao), setor=VALUES(setor), ramal=VALUES(ramal)""",[cite: 1]
                (col.get('id'), col.get('nome'), col.get('funcao', 'Ajudante'), col.get('setor', 'TI'), col.get('ramal', ''), col.get('cor', 'blue'))[cite: 1]
            )[cite: 1]

        for c in chamados:[cite: 1]
            cursor.execute([cite: 1]
                """INSERT INTO chamados (id, setor, responsavel, categoria, urgencia, descricao, status, resultado, parecer_tecnico, ajudantes_json, comentarios_json, data_abertura, data_resolucao)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                   ON DUPLICATE KEY UPDATE
                     status=VALUES(status), resultado=VALUES(resultado), parecer_tecnico=VALUES(parecer_tecnico),
                     ajudantes_json=VALUES(ajudantes_json), comentarios_json=VALUES(comentarios_json), data_resolucao=VALUES(data_resolucao)""",[cite: 1]
                (
                    c.get('id'), c.get('setor'), c.get('responsavel'), c.get('categoria'),[cite: 1]
                    c.get('urgencia', 'Normal'), c.get('descricao', ''), c.get('status', 'aberto'),[cite: 1]
                    c.get('resultado'), c.get('parecerTecnico', ''),[cite: 1]
                    json.dumps(c.get('ajudantes', []), ensure_ascii=False),[cite: 1]
                    json.dumps(c.get('comentarios', []), ensure_ascii=False),[cite: 1]
                    c.get('dataAbertura'), c.get('dataResolucao')[cite: 1]
                )[cite: 1]
            )[cite: 1]

        conn.commit()[cite: 1]
        cursor.close()[cite: 1]
        conn.close()[cite: 1]
        return jsonify({'ok': True, 'msg': 'Sincronizado com MySQL com sucesso!'})[cite: 1]
    except Exception as e:[cite: 1]
        return jsonify({'ok': False, 'error': str(e)}), 500[cite: 1]

if __name__ == '__main__':[cite: 1]
    hostname = socket.gethostname()[cite: 1]
    local_ip = socket.gethostbyname(hostname)[cite: 1]
    print("====================================================================")[cite: 1]
    print(f"🚀 Servidor Python/Flask + MySQL rodando!")[cite: 1]
    print(f"💻 Localhost:   http://localhost:3000")[cite: 1]
    print(f"🌐 Rede Local:  http://{local_ip}:3000")[cite: 1]
    print("====================================================================")[cite: 1]
    app.run(host='0.0.0.0', port=3000, debug=True)[cite: 1]

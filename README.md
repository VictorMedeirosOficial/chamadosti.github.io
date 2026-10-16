# 📋 Portal de Chamados TI — Ambiente Completo (MySQL + Localhost + Rede Interna)

Este pacote contém a aplicação web completa do **HelpDesk TI**, já pré-configurada para rodar em **Localhost (`http://localhost:3000`)**, liberar acesso para os computadores da **Rede Interna (`0.0.0.0:3000`)** e salvar todas as informações em um banco de dados **MySQL (`helpdesk_ti`)**.

---

## ✨ O Que Foi Atualizado Nesta Versão

1. **📷 Alterar Imagem e Perfil do TI**:
   - Clique diretamente sobre a foto do técnico no Painel de Chamados ou no botão **"📷 Alterar Imagem do TI"** para enviar uma foto do computador/celular, colar uma URL de imagem ou escolher um avatar predefinido, além de editar nome, cargo e ramal.
2. **👥 Colaboradores / Ajudantes nos Chamados**:
   - Cadastre colaboradores da equipe e vincule ajudantes tanto na abertura da solicitação quanto diretamente nos cards do Kanban (**"+ Adicionar Ajudante"**) ou no fechamento do chamado.
   - Filtre os chamados por colaborador/ajudante na barra de ferramentas.
3. **✍️ Setor Solicitante em Aberto para Digitar**:
   - O campo de setor agora é um campo de texto livre para digitar qualquer setor ou sala, contando também com botões rápidos de preenchimento opcional em 1 clique.
4. **🚫 Sem Tempo Estimado para Resolver (Sem SLA Fixo)**:
   - Foram removidas todas as estimativas de tempo de resolução dos cards de categoria, do formulário, do painel Kanban e dos detalhes.
5. **📝 Descrição Detalhada Não Obrigatória (Opcional)**:
   - O solicitante pode abrir o chamado rapidamente apenas informando Setor, Responsável e Categoria, deixando a descrição detalhada em branco se preferir.
6. **⚡ Interatividade Aprimorada**:
   - **Arrastar e Soltar (Drag & Drop)** nos cards entre as colunas *Em Aberto*, *Na Espera* e *Concluídos*.
   - **Chat / Linha do Tempo de Acompanhamento** dentro dos detalhes de cada chamado.
   - **Nível de Urgência Visual** (*Normal*, *Alta*, *Urgente*), **Modo Escuro (Dark Mode)** e **Exportação para CSV**.
7. **🗄️ Ambiente Preparado para MySQL + Localhost Pré-Configurado**:
   - Front-end com painel **"🗄️ MySQL / Localhost"** no topo da página e sincronização híbrida automática (`LocalStorage` + API REST `http://localhost:3000/api`).

---

## 📁 Estrutura de Arquivos do Pacote

```text
portal_chamados_ti_mysql/
├── index.html                        # Aplicação principal (usa assets/images/tecnico_ti.jpg)
├── sistema_chamados_ti.html          # Versão autônoma em arquivo único (imagens embutidas)
├── database/
│   └── database.sql                  # Script SQL para criar o banco e tabelas no MySQL
├── assets/
│   └── images/
│       └── tecnico_ti.jpg            # Foto padrão do técnico de TI
├── server.js                         # Servidor Backend em Node.js + Express + MySQL2 (Porta 3000)
├── package.json                      # Dependências Node.js (express, mysql2, cors, dotenv)
├── .env                              # Variáveis pré-configuradas (localhost, root, helpdesk_ti)
├── server.py                         # Alternativa de Servidor Backend em Python (Flask + MySQL)
├── requirements.txt                  # Dependências Python
├── iniciar_localhost_node.bat        # Inicializador de 1 clique para Windows (Node.js)
├── iniciar_localhost_python.bat      # Inicializador de 1 clique para Windows (Python)
└── README.md                         # Este guia passo a passo
```

---

## 🗄️ Passo 1: Preparar o Banco de Dados MySQL

1. Instale e inicie o seu servidor **MySQL** (você pode usar o **XAMPP**, **WAMP**, **Laragon** ou **MySQL Community Server**).
   - Se usar o **XAMPP**, abra o *XAMPP Control Panel* e clique em **Start** no módulo **MySQL** (porta padrão `3306`).
2. Importe o arquivo `database/database.sql` (opcional, pois o `server.js` também cria o banco e as tabelas automaticamente ao iniciar!):
   - Pelo **phpMyAdmin** (`http://localhost/phpmyadmin`) ou **MySQL Workbench**: vá em **Importar** e selecione `database/database.sql`.
   - Ou via terminal:
     ```bash
     mysql -u root -p < database/database.sql
     ```
3. Se o seu MySQL tiver senha no usuário `root`, basta colocá-la no arquivo `.env` (`DB_PASSWORD=sua_senha`). Por padrão, ele já vem pré-configurado para `host: localhost`, `port: 3306`, `user: root` e `database: helpdesk_ti`.

---

## 🚀 Passo 2: Rodar o Servidor Localhost e Liberar na Rede

Você pode escolher rodar o servidor com **Node.js** ou com **Python**:

### Opção A: Usando Node.js (Recomendado)
No terminal do **VS Code** (ou clicando duas vezes em `iniciar_localhost_node.bat` no Windows):
```bash
npm install
npm start
```

### Opção B: Usando Python (Flask)
No terminal do **VS Code** (ou clicando duas vezes em `iniciar_localhost_python.bat` no Windows):
```bash
pip install -r requirements.txt
python server.py
```

### 🌐 Endereços de Acesso:
- **Na própria máquina do servidor (Localhost):**
  `http://localhost:3000`
- **Nos outros computadores e celulares da mesma rede Wi-Fi/Cabo:**
  `http://<IP-DO-SEU-COMPUTADOR>:3000` (o terminal mostrará automaticamente o IP exato da sua máquina assim que o servidor iniciar!).
````[cite: 4]

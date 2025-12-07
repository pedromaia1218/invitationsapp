# Sistema de Gestão de Convites

Sistema simples de gerenciamento de convites com autenticação, e API REST com OAuth2.

## 🚀 Tecnologias utilizadas

- **Ruby 3.2.2**
- **Rails 7.1.3.4**
- **PostgreSQL 15**
- **Docker**
- **Docker Compose**
- **Devise** - Autenticação
- **Doorkeeper** - OAuth2 Provider
- **u-case** - Padrão de Use Cases
- **Kaminari** - Paginação

Testes feitos com
- **RSpec**
- **Factory Bot**
- **Shoulda Matchers**

## 📋 Pré-requisitos

- Docker
- Docker Compose
- Git

## 🔧 Instalação

### 1. Clone o repositório

```bash
git clone git@github.com:pedromaia1218/invitationsapp.git
cd invitationsapp
```

### 2. Build da imagen de desenvolvimento

```bash
docker compose build dev
```

### 3. Crie o banco de dados, rode as migrations e rode a população inicial

```bash
docker compose run dev bundle exec rails db:create db:migrate db:seed
```

> **Nota:** Nessa etapa é possível ocorrer um erro de porta indisponível caso a porta 5435 já esteja ocupada por outra aplicação, nesse caso alterar a porta "5435:5432" na linha 5 do arquivo docker-compose.yml para alguma outra disponível

Isso criará:
1. Admin padrão para testes com:
    - Email: `teste@teste.com`
    - Senha: `qwe123`
2. Aplicação OAuth para testes da API (client_id e client_secret necessários para gerar o token do doorkeeper)

### 4. Inicie o servidor

```bash
docker compose up dev
```

O sistema estará disponível em: **http://localhost:3000**

## 🧪 Rodando os Testes

### Primeiro faça o build do ambiente de testes e banco de dados também utilizando:
```bash
docker compose build test
docker compose run test bundle exec rails db:create db:migrate
```

### Todos os testes

```bash
docker compose run test bundle exec rspec
```

### Testes específicos

```bash
# Testes de models
docker compose run test bundle exec rspec spec/models

# Testes de controllers
docker compose run test bundle exec rspec spec/controllers

# Teste específico
docker compose run test bundle exec rspec spec/models/invitation_spec.rb
```

## 🌐 Interface Web

Após iniciar o servidor, acesse:

1. **Login**: http://localhost:3000
   - Email: `teste@teste.com`
   - Senha: `qwe123`

2. **Funcionalidades disponíveis:**
   - Gerenciamento de Administradores
   - CRUD de Empresas (com validação de CNPJ)
   - CRUD de Convites (com tipos: CPF (com validação), Email ou Código)
   - Filtros na tela de convites por nome, empresa e intervalo de datas
   - Gerenciamento de Aplicações OAuth

> **Nota:** Para testes criando empresas ou convites com cpf, utilizar algum gerador de CNPJ/CPF como: https://www.4devs.com.br/gerador_de_cnpj


## 🔐 API REST (OAuth2)

### Gerando um token de acesso via terminal

#### Opção 1: Com credenciais de usuário (Password Grant)

```bash
curl -X POST http://localhost:3000/oauth/token \
  -d 'grant_type=password' \
  -d 'username=teste@teste.com' \
  -d 'password=qwe123' \
  -d 'client_id=SEU_CLIENT_ID' \
  -d 'client_secret=SEU_CLIENT_SECRET'
```

#### Opção 2: Apenas com credenciais da aplicação (Client Credentials)

```bash
curl -X POST http://localhost:3000/oauth/token \
  -d 'grant_type=client_credentials' \
  -d 'client_id=SEU_CLIENT_ID' \
  -d 'client_secret=SEU_CLIENT_SECRET'
```

> **Nota:** Os valores de `client_id` e `client_secret` são exibidos após rodar `rails db:seed` ou podem ser visualizados em http://localhost:3000/oauth/applications após logado

### Endpoints da API utilizando o terminal

#### Listar convites

```bash
curl -H "Authorization: Bearer SEU_TOKEN" \
  "http://localhost:3000/api/v1/invitations"
```

#### Buscar convite específico

```bash
curl -H "Authorization: Bearer SEU_TOKEN" \
  http://localhost:3000/api/v1/invitations/1
```

#### Criar convite

```bash
curl -X POST http://localhost:3000/api/v1/invitations \
  -H "Authorization: Bearer SEU_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "invitation": {
      "username": "Usuario Teste",
      "company_id": 1,
      "invitation_type": "cpf",
      "cpf": "72948379024",
      "active": true
    }
  }'
```

> **Nota:** Para criar um convite é necessário atrelar a uma empresa, como foram feitos apenas a api de convites, é preciso criar uma empresa via web

#### Atualizar convite

```bash
curl -X PATCH http://localhost:3000/api/v1/invitations/:id \
  -H "Authorization: Bearer SEU_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "invitation": {
      "active": false
    }
  }'
```

#### Deletar convite

```bash
curl -X DELETE http://localhost:3000/api/v1/invitations/:id \
  -H "Authorization: Bearer SEU_TOKEN"
```

## 📁 Estrutura do Projeto

```
app/
├── controllers/
│   ├── api/v1/              # Controllers da API REST
│   ├── admins_controller.rb
│   ├── companies_controller.rb
│   └── invitations_controller.rb
├── models/
│   ├── use_cases/           # Lógica de negócio
│   │   ├── admins/
│   │   ├── companies/
│   │   └── invitations/
│   ├── admin.rb
│   ├── company.rb
│   └── invitation.rb
└── views/                   # Views HTML

spec/                        # Testes
```
# CodeCombat - Interfaces Web Disponíveis

## 🎮 Aplicação CodeCombat
```
http://localhost:7777
```
- Aplicação principal do CodeCombat
- Porta: 7777 (containers Docker)
- Porta: 3000 (desenvolvimento local npm)

---

## 🗄️ MongoDB Express (Database Manager)
```
http://localhost:8082
```
- Gerenciar dados do MongoDB
- Visualizar collections
- CRUD de documentos
- Importar/exportar dados

**Credenciais:**
- Sem autenticação (por padrão em desenvolvimento)

---

## 🚀 Redis Commander (Cache Manager)
```
http://localhost:8081
```
- Gerenciar dados em cache (Redis)
- Visualizar keys e valores
- Monitor em tempo real
- Clear cache

---

## 📊 Resumo de Portas

| Serviço | Porta | Tipo | Interface |
|---------|-------|------|-----------|
| **CodeCombat** | 7777 | Web | ✅ HTTP |
| **MongoDB** | 27017 | Native | ❌ Binário (use Express) |
| **Redis** | 6379 | Native | ❌ Binário (use Commander) |
| **MongoDB Express** | 8082 | Web | ✅ HTTP |
| **Redis Commander** | 8081 | Web | ✅ HTTP |

---

## 🐳 Acessar via Docker

```bash
# Listar containers
docker ps

# Ver logs
docker-compose logs -f

# Acessar container
docker-compose exec mongo mongosh coco

# Acessar Redis
docker-compose exec redis redis-cli
```

---

## 🚨 IMPORTANTE

⚠️ **Nunca acesse diretamente via HTTP:**
- `http://localhost:27017/` ❌ Erro MongoDB
- `http://localhost:6379/` ❌ Erro Redis

✅ **Use as ferramentas web:**
- MongoDB → MongoDB Express (porta 8082)
- Redis → Redis Commander (porta 8081)

---

## 📁 Estrutura Docker

```
docker-compose.yml
├── proxy (CodeCombat app) → port 7777
├── mongo (MongoDB) → port 27017
│   └── mongo-express → port 8082
├── redis (Redis cache) → port 6379
└── redis-commander → port 8081
```

---

## 🔧 Para Production

Em produção, **desabilite**:
1. MongoDB Express (segurança)
2. Redis Commander (segurança)

Use credenciais e autenticação apropriadas no `.env`

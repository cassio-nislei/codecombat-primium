# CodeCombat Setup - Stripe & API Configuration

## 📋 Configuração Rápida

### 1. Clonar Variáveis de Ambiente

```bash
cp .env.example .env
```

### 2. Preencher .env com Suas Chaves (Produção)

Edite o arquivo `.env` e adicione suas chaves reais de produção:

```bash
# Stripe (https://dashboard.stripe.com/apikeys)
COCO_STRIPE_SECRET_KEY=sk_live_SEU_LIVE_KEY_AQUI

# GitHub OAuth (https://github.com/settings/developers)
COCO_GITHUB_CLIENT_SECRET=seu_github_secret_aqui

# CloudFlare API (https://dash.cloudflare.com/)
COCO_CLOUDFLARE_API_KEY=seu_cf_key_aqui
COCO_CLOUDFLARE_API_EMAIL=seu_email@cloudflare.com

# Close.io API (https://app.close.io/api/)
COCO_CLOSEIO_API_KEY=seu_closeio_key_aqui

# Google reCAPTCHA (https://www.google.com/recaptcha/admin)
COCO_GOOGLE_RECAPTCHA_SECRET_KEY=seu_recaptcha_secret_aqui

# PayPal (https://developer.paypal.com/)
COCO_PAYPAL_CLIENT_SECRET=seu_paypal_secret_aqui

# SendGrid (https://sendgrid.com/)
COCO_SENDGRID_API_KEY=seu_sendgrid_key_aqui

# Node Environment
NODE_ENV=production  # ou 'development'
```

### 3. Rodar com Docker Compose

```bash
docker-compose up --build
```

Acessar em: **http://localhost:7777**

---

## 🔑 Configurações Necessárias

Para desenvolvimento completo, configure as seguintes variáveis de ambiente no arquivo `.env`:

- **Stripe Secret Key**: Solicitar para a equipe dev ou criar conta em https://dashboard.stripe.com
- **GitHub Client Secret**: Criar em https://github.com/settings/developers  
- **PayPal Secret**: Criar em https://developer.paypal.com

⚠️ **Importante**: Nunca commit `.env` com segredos reais. Use `.env.example` como referência.

---

## 📍 Localização das Configurações no Código

### Backend (Node.js)
- **Arquivo**: `server_config.coffee`
- **Variável**: `process.env.COCO_STRIPE_SECRET_KEY` (padrão: empty string, requer variável de ambiente)

### Frontend (Vue.js)
- **Arquivo**: `app/core/services/stripe.coffee`
- **Chave Pública Teste**: `pk_test_zG5UwVu6Ww8YhtE9ZYh0JO6a`
- **Chave Produção**: `pk_live_27jQZozjDGN1HSUTnSuM578g`

---

## 🚀 Para Produção

1. **Gerar chaves reais** em cada serviço (Stripe, GitHub, etc)
2. **Alterar NODE_ENV** para `production` no `.env`
3. **Deployer** com:
   ```bash
   docker-compose -f docker-compose.yml up -d
   ```

---

## 🔒 Segurança

⚠️ **IMPORTANTE**: 
- Nunca faça commit do arquivo `.env` com chaves reais
- Use `.env.example` para referência
- Adicione `.env` ao `.gitignore` (já deve estar)
- As variáveis de ambiente são injetadas automaticamente

---

## 🛠️ Troubleshooting

**Erro: Stripe rejected request**
- Verifique se `COCO_STRIPE_SECRET_KEY` está correto
- Use `sk_test_` para teste, `sk_live_` para produção

**Erro: CORS/GitHub auth falha**
- Verifique `COCO_GITHUB_CLIENT_SECRET`
- Configure callback URL no GitHub OAuth app

**MongoDB não conecta**
- Verifique se `MONGO_URL` está correto
- O container mongo deve estar rodando: `docker-compose ps`

---

**Documentação do docker-compose.yml:**
- Serviço `proxy`: Aplicação CodeCombat
- Serviço `mongo`: Database MongoDB 6
- Serviço `redis`: Cache Redis 7
- Todas as chaves são injetadas automaticamente do `.env`

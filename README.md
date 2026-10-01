# Gastos Mensais

Controle financeiro mensal com login: cada pessoa tem a própria conta e só vê os próprios lançamentos.

- O **site** fica no GitHub Pages (grátis).
- O **login e os dados** ficam no [Supabase](https://supabase.com) (plano gratuito).

## Arquivos

| Arquivo | Para que serve |
|---|---|
| `index.html` | O site |
| `config.js` | Endereço e chave pública do seu projeto Supabase |
| `supabase/schema.sql` | Cria a tabela e as regras de acesso |
| `controle-financeiro.html` | Versão antiga, só no navegador. Fica só no seu computador (está no `.gitignore`), serve para exportar os dados antigos |

## 1. Criar o banco no Supabase

1. Crie uma conta em https://supabase.com e clique em **New project**. Escolha a região **South America (São Paulo)**.
2. No menu lateral, abra **SQL Editor** e clique em **New query**. Cole todo o conteúdo de `supabase/schema.sql` e clique em **Run**.
3. Abra **Project Settings > API Keys** e copie:
   - a **Project URL** (`https://xxxx.supabase.co`), que também aparece em **Project Settings > Data API**;
   - a chave **anon** ou **publishable**. **Não** use a `service_role` ou `secret`.
4. Cole os dois valores em `config.js`.

## 2. Publicar no GitHub Pages

1. Crie um repositório no GitHub, por exemplo `gastos-mensais`. Ele pode ser público: os dados não ficam no repositório.
2. Envie os arquivos desta pasta para o repositório.
3. No repositório, abra **Settings > Pages**. Em **Source**, escolha **Deploy from a branch**, depois a branch **main**, pasta **/ (root)**, e clique em **Save**.
4. Em cerca de 1 minuto o site estará em `https://SEU-USUARIO.github.io/gastos-mensais/`.

## 3. Ajustar o login no Supabase

1. Abra **Authentication > URL Configuration**:
   - Em **Site URL**, coloque o endereço do site, por exemplo `https://SEU-USUARIO.github.io/gastos-mensais/`.
   - Em **Redirect URLs**, adicione o mesmo endereço.

   Isso faz os links de confirmação de e-mail e de troca de senha voltarem para o site.
2. Abra o site e crie as duas contas (a sua e a da sua esposa) em **Criar conta**. Confirme o e-mail de cada uma.
3. **Feche novos cadastros.** Em **Authentication > Sign In / Providers**, desative **Allow new users to sign up**. Assim ninguém mais consegue criar conta no site.

## 4. Trazer os dados da versão antiga

1. Abra `controle-financeiro.html` no mesmo navegador de antes e clique em **Backup completo**.
2. No site novo, entre na conta e clique em **Importar backup**. Lançamentos repetidos são ignorados.

## Segurança

- A chave em `config.js` é pública por natureza: qualquer site com Supabase expõe essa chave. Quem protege os dados são as regras **Row Level Security** do `schema.sql`, que só deixam cada usuário ler e alterar as próprias linhas.
- Nunca coloque a chave `service_role` ou `secret` no site.
- Projetos gratuitos do Supabase ficam pausados depois de 7 dias sem uso. Se isso acontecer, entre no painel do Supabase e clique em **Restore**. Seus dados não são apagados.

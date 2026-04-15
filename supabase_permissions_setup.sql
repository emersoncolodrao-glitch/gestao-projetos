-- ============================================================
-- user_permissions — controle de acesso por recurso
-- ============================================================
-- resource_type valores:
--   'restricted'      → sentinela: indica que o usuário tem restrições configuradas (resource_id = NULL)
--   'projeto'         → acesso ao projeto (resource_id = projeto.id)
--   'proj_kanban'     → aba Kanban do projeto (resource_id = projeto.id)
--   'proj_lista'      → aba Lista do projeto  (resource_id = projeto.id)
--   'proj_cronograma' → aba Cronograma        (resource_id = projeto.id)
--   'proj_custos'     → aba Custos            (resource_id = projeto.id)
--   'indicador'       → acesso ao indicador   (resource_id = indicador.id)
--   'cadastros'       → acesso a Configurações (resource_id = NULL)
--
-- Lógica:
--   Sem linha 'restricted' → usuário não configurado → acesso total
--   Com linha 'restricted' → acesso restrito apenas aos ids listados (Set vazio = sem acesso)
--   Admin sempre enxerga tudo (verificado em JS).
-- ============================================================

CREATE TABLE IF NOT EXISTS user_permissions (
  id            bigserial PRIMARY KEY,
  user_id       uuid        NOT NULL,
  resource_type text        NOT NULL CHECK (resource_type IN (
                  'restricted',
                  'projeto','proj_kanban','proj_lista','proj_cronograma','proj_custos',
                  'indicador','agmrelatorio','cadastros'
                )),
  resource_id   bigint,                -- NULL para 'restricted' e 'cadastros'
  created_at    timestamptz DEFAULT now(),
  UNIQUE (user_id, resource_type, resource_id)
);

-- Se a tabela já existia com o CHECK antigo, execute o bloco abaixo para atualizar:
ALTER TABLE user_permissions DROP CONSTRAINT IF EXISTS user_permissions_resource_type_check;
ALTER TABLE user_permissions ADD CONSTRAINT user_permissions_resource_type_check
  CHECK (resource_type IN (
    'restricted',
    'projeto','proj_kanban','proj_lista','proj_cronograma','proj_custos',
    'indicador','agmrelatorio','cadastros'
  ));

-- Índice para busca rápida por usuário
CREATE INDEX IF NOT EXISTS idx_user_permissions_user_id ON user_permissions (user_id);

-- RLS
ALTER TABLE user_permissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_permissions_select_own"
  ON user_permissions FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "user_permissions_admin_all"
  ON user_permissions FOR ALL
  USING (true)
  WITH CHECK (true);

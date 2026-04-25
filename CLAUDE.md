ProjectFlow - Especificações Técnicas e de Negócio
1. Visão Geral
O ProjectFlow é uma aplicação Single-Page (SPA) de gestão de projetos e indicadores, construída com HTML5, CSS3 moderno (Custom Properties) e JavaScript Vanilla. A persistência de dados e autenticação são gerenciadas pelo Supabase.

2. Pilha Tecnológica
Backend-as-a-Service: Supabase (Auth, REST API, Storage).

Estilização: CSS nativo com arquitetura baseada em variáveis (:root).

Comunicação: Fetch API com interceptação para renovação automática de JWT (withTokenRefresh).

Componentes: Renderização dinâmica via manipulação de DOM baseada em estado (let db).

3. Estrutura de Dados (Mapeamento DB)
O projeto utiliza um objeto global db que espelha as tabelas do Supabase:

empresas, responsaveis, categorias, projetos, tarefas.

indicadores, indicador_metas, indicador_comentarios, objetivos_estrategicos.

tarefa_tags, tarefa_responsaveis, tarefa_anexos.

tarefa_comentarios (comentários por tarefa — mesma estrutura de indicador_comentarios, vinculada a tarefas).

agm_registros (Análise de Gestão Mensal).

4. Funcionalidades Principais
A. Gestão de Projetos
Visualizações: Tabela detalhada e Grade de Cards.

Kanban: Suporta Drag-and-Drop para mudança de status e reordenação interna (através da propriedade kanban_ordem).

Cronograma (Gantt): Renderização visual de prazos em SVG/HTML.

Custos: Controle financeiro por categoria com filtros de período (7d, 30d, mês atual).

B. Gestão de Indicadores (AGM)
Cálculos: Suporta indicadores onde "Menor é Melhor" (inversão de cores lógica).

Variações: Cálculos automáticos de YoY (Year over Year) e MoM (Month over Month).

Metas: Lançamento mensal de previsto vs realizado.

Relatório AGM: Consolidação de indicadores, anotações e planos de ação por responsável.

Mapa Estratégico: Visualização dos indicadores agrupados por perspectivas estratégicas.

C. Segurança e Permissões
Sistema de Permissões: Baseado na tabela user_permissions.

Níveis: Usuários podem ter acesso restrito a projetos específicos ou abas específicas (ex: ocultar aba de Custos).

Admin: Acesso total via flag is_admin no perfil.

5. Convenções de Código
Estado: O estado da UI é controlado por variáveis como view, projId, projTab.

Renderização: Funções renderXXXX() limpam e reconstroem o innerHTML do container principal.

Formatação: Helpers globais como fmtDate, fmtBRL e fmtVar garantem consistência.

Modais: Sistema próprio de modais injetados no modalRoot.

6. Instruções para Manutenção/Evolução
Ao adicionar campos, atualize os mapeadores fromDB e toDB.

Para novos filtros na Tabela, siga o padrão de debounce e atualização de estado global.

Novas abas de projeto devem ser registradas na função canSeeTab e na lógica de switchTab.

7. Migrações de Banco de Dados
Toda alteração de schema (novos campos, novas tabelas, constraints, RLS) deve ser registrada em sql/supabase_migrations_2026.sql, seguindo o padrão já estabelecido: bloco numerado com comentário explicando o motivo da mudança. As migrações devem ser aplicadas no SQL Editor do Supabase em ordem crescente.